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

            // 🌀 Loader animado de SpinKit
            if (responseState is Loading) {
              return Stack(
                children: [
                  Container(color: Colors.black.withOpacity(0.05)),
                  const Center(
                    child: SpinKitThreeBounce(
                      color: Colors.orange,
                      size: 30,
                      duration: Duration(seconds: 1),
                    ),
                  ),
                ],
              );
            }

            if (responseState is Success<List<Order>>) {
              final orders = responseState.data;

              if (orders.isEmpty) {
                return const Center(child: Text("No tienes órdenes aún"));
              }

              return RefreshIndicator(
                color: Colors.orange,
                onRefresh: () async {
                  _bloc.add(RefreshOrders(context));
                  await Future.delayed(const Duration(seconds: 1));
                  Fluttertoast.showToast(
                    msg: "Órdenes actualizadas correctamente",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER_LEFT,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return ClientOrderListItem(orders[index]);
                  },
                ),
              );
            }

            if (responseState is Error) {
              return const Center(child: Text("Error al obtener las órdenes"));
            }

            return const Center(child: Text("Cargando órdenes..."));
          },
        ),
      ),
    );
  }
}
