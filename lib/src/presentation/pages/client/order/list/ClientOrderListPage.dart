import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/ClientOrderListItem.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/bloc/ClientOrderListBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/bloc/ClientOrderListEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/bloc/ClientOrderListState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientOrderListPage extends StatefulWidget {
  const ClientOrderListPage({super.key});

  @override
  State<ClientOrderListPage> createState() => _ClientOrderListPageState();
}

class _ClientOrderListPageState extends State<ClientOrderListPage> {
  late ClientOrderListBloc _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(GetOrders(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ClientOrderListBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<ClientOrderListBloc, ClientOrderListState>(
        listener: (context, state) {
          final responseState = state.response;
          if (responseState is Error) {
            Fluttertoast.showToast(
              msg: responseState.message,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.redAccent,
            );
          }
        },
        child: BlocBuilder<ClientOrderListBloc, ClientOrderListState>(
          builder: (context, state) {
            final responseState = state.response;

            // 🧡 Pantalla de carga moderna
            if (responseState is Loading) {
              return _buildLoadingScreen();
            }

            // ✅ Cuando hay órdenes cargadas correctamente
            if (responseState is Success<List<Order>>) {
              final orders = responseState.data;

              return RefreshIndicator(
                color: Colors.orange,
                onRefresh: () async {
                  final completer = Completer<void>();
                  StreamSubscription<ClientOrderListState>? subscription;

                  subscription = _bloc.stream.listen((state) {
                    final response = state.response;
                    if (response is Success || response is Error) {
                      subscription?.cancel();
                      completer.complete();
                    }
                  });

                  _bloc.add(RefreshOrders(context));
                  await completer.future;

                  if (mounted && _bloc.state.response is Success) {
                    Fluttertoast.showToast(
                      msg: "Órdenes actualizadas",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 14.0,
                    );
                  }
                },
                child: orders.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          alignment: Alignment.center,
                          child: Text(
                            "No tienes órdenes aún",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          return ClientOrderListItem(orders[index]);
                        },
                      ),
              );
            }

            // ❌ Error
            if (responseState is Error) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  alignment: Alignment.center,
                  child: Text(
                    "Error al obtener las órdenes",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }

            // Estado inicial o desconocido
            return _buildLoadingScreen();
          },
        ),
      ),
    );
  }

  /// 🧡 Pantalla de carga elegante con texto
  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitThreeBounce(
              color: Colors.orange,
              size: 35,
              duration: Duration(milliseconds: 1200),
            ),
            const SizedBox(height: 20),
            Text(
              'Cargando tus órdenes...',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}