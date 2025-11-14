import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/OrdersServices.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart' as addr;
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/ClientShoppingBagBottomBar.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/ClientShoppingBagItem.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/shoppingbag/bloc/ClientShoppingBagState.dart';
import 'package:flutter_application_1/src/presentation/utils/showOrderTypeModal.dart';
import 'package:flutter_application_1/src/presentation/utils/showPaymentMethodDialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientShoppingBagPage extends StatefulWidget {
  const ClientShoppingBagPage({super.key});

  @override
  State<ClientShoppingBagPage> createState() => _ClientShoppingBagPageState();
}

class _ClientShoppingBagPageState extends State<ClientShoppingBagPage> {
  ClientShoppingBagBloc? _bloc;
  String selectedOrderType = 'sitio';
  int? selectedAddressId;
  addr.Address? selectedAddress;
  String? noteText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<ClientShoppingBagBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc?.add(GetShoppingBag());
      _bloc?.add(GetTotal());
      _checkAndShowHint(); //Mostrar el diálogo de ayuda al iniciar
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ClientShoppingBagBloc>(context);

    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          body: BlocBuilder<ClientShoppingBagBloc, ClientShoppingBagState>(
            builder: (context, state) {
              if (state.products.isEmpty) {
                return Center(
                  child: Text(
                    'Tu bolsa está vacía',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  return ClientShoppingBagItem(
                    _bloc,
                    state,
                    state.products[index],
                  );
                },
              );
            },
          ),
          bottomNavigationBar:
              BlocBuilder<ClientShoppingBagBloc, ClientShoppingBagState>(
                builder: (context, state) {
                  return ClientShoppingBagBottomBar(
                    state,
                    selectedOrderType: selectedOrderType,
                    selectedAddressId: selectedAddressId,
                    onConfirmOrder: () => _confirmOrder(context, state),
                  );
                },
              ),
        ),

        //Overlay de loading
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.40),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SpinKitThreeBounce(
                    color: Colors.white,
                    size: 32,
                    duration: Duration(milliseconds: 900),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Procesando tu orden...",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  ///Verifica si el aviso ya se mostró antes
  Future<void> _checkAndShowHint() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenHint = prefs.getBool('hasSeenBagHint') ?? false;

    if (!hasSeenHint) {
      await Future.delayed(const Duration(milliseconds: 600)); // Espera breve
      _showHintDialog(context);
      prefs.setBool('hasSeenBagHint', true);
    }
  }

  ///Diálogo elegante de aviso
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
                // 🛍️ Ícono circular con degradado naranja
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
                    Icons.shopping_bag_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),

                const SizedBox(height: 20),

                //Título principal
                Text(
                  '¡Tu Bolsa de Compras!',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),

                // 📝 Texto explicativo dividido en dos secciones
                Column(
                  children: [
                    Text(
                      'Aquí podrás ver todos los productos que has agregado. '
                      'Cuando estés listo, toca “Ordenar” para confirmar tu pedido.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Usa los botones “+” y “–” para ajustar la cantidad de cada producto.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                //Botón "Entendido"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
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

  ///Abre el modal para seleccionar tipo de pedido
  void _confirmOrder(BuildContext context, ClientShoppingBagState state) {
    if (state.products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes agregar al menos un producto')),
      );
      return;
    }

    showOrderTypeModal(
      context,
      selectedAddress,
      selectedOrderType: selectedOrderType,
      selectedAddressId: selectedAddressId,
      onOrderTypeChanged: (type) {
        setState(() => selectedOrderType = type);
      },
      onAddressSelected: (id) {
        setState(() => selectedAddressId = id);
      },
      onAddressObjectSelected: (addr.Address? address) {
        setState(() => selectedAddress = address);
      },
      onNoteChanged: (note) {
        setState(() => noteText = note);
      },
      onConfirm:
          (String? arrivalTime) => _createOrder(context, state, arrivalTime),
    );
  }

  ///Crea la orden en el backend y muestra el modal de pago
  Future<void> _createOrder(
    BuildContext context,
    ClientShoppingBagState state,
    String? arrivalTime,
  ) async {
    setState(() => _isLoading = true);

    try {
      final authResponse = await _bloc!.authUseCases.getUserSession.run();
      final clientId = authResponse!.cliente.id!;
      final ordersService = OrdersService();

      List<Map<String, dynamic>> items =
          state.products.map((product) {
            return {
              'product_id': product.id,
              'quantity': product.quantity,
              'unit_price': product.price,
            };
          }).toList();

      final response = await ordersService.createOrder(
        clientId: clientId,
        context: context,
        restaurantId: 1,
        statusId: 1,
        addressId: selectedAddressId,
        orderType: selectedOrderType,
        note: noteText,
        items: items,
        arrivalTime: arrivalTime,
      );

      setState(() => _isLoading = false);

      if (response is Success<Order>) {
        final order = (response as Success<Order>).data;

        _bloc?.add(ClearShoppingBag());

        showPaymentMethodModal(
          context,
          order.id,
          order.total,
          order.restaurant,
          onPaymentSuccess: () {
            Navigator.pushNamed(
              context,
              'client/order/confirmation',
              arguments: order,
            );
          },
        );
      } else if (response is Error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al crear orden: ${(response as Error).message}',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error desconocido al crear la orden')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error inesperado: $e')));
    }
  }
}
