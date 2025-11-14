import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/ClientOrderListItem.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/bloc/ClientOrderListBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/bloc/ClientOrderListEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/list/bloc/ClientOrderListState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _bloc = BlocProvider.of<ClientOrderListBloc>(context); // inicializa aquí

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(GetOrders(context));
      _checkAndShowHint(); // se ejecuta después de cargar
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
          // Detección de token expirado
          if (responseState is Error) {
            if (responseState.message.contains('Sesión expirada')) {
              Fluttertoast.showToast(
                msg:
                    "Tu sesión ha expirado. Por favor, inicia sesión nuevamente.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.orange,
                textColor: Colors.white,
              );

              // Redirigir al login y eliminar la navegación previa
              Navigator.pushNamedAndRemoveUntil(
                context,
                'login',
                (route) => false,
              );
              return;
            }

            // 🔥 Errores normales (no relacionados con sesión)
            Fluttertoast.showToast(
              msg: responseState.message, // deja el resto de errores igual
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.redAccent,
            );
          }
        },
        child: BlocBuilder<ClientOrderListBloc, ClientOrderListState>(
          builder: (context, state) {
            final responseState = state.response;

            // Pantalla de carga moderna
            if (responseState is Loading) {
              return _buildLoadingScreen();
            }

            // Cuando hay órdenes cargadas correctamente
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
                child:
                    orders.isEmpty
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

            // Error general (solo si no fue detectado arriba)
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

  /// Verifica si el aviso ya se mostró antes
  Future<void> _checkAndShowHint() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenHint = prefs.getBool('hasSeenOrdersHint') ?? false;

    if (!hasSeenHint) {
      await Future.delayed(const Duration(milliseconds: 600)); // Espera breve
      _showHintDialog(context);
      prefs.setBool('hasSeenOrdersHint', true);
    }
  }

  void _showHintDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🧾 Ícono circular con degradado naranja
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),

                const SizedBox(height: 20),

                // Título
                Text(
                  '¡Revisa tus órdenes!',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),

                // Texto explicativo
                Column(
                  children: [
                    Text(
                      'Aquí podrás ver todas las órdenes que has realizado. '
                      'Revisa su estado y el método de pago fácilmente.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Desliza hacia abajo para actualizar la lista y ver tus pedidos más recientes.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Botón "Entendido"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Entendido',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Pantalla de carga elegante con texto
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
