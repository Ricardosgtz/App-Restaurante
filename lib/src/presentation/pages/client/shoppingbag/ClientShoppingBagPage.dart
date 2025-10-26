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
import 'package:flutter_application_1/src/presentation/widgets/HomeAppBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  bool _isLoading = false; // 🟢 Control del loading

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc?.add(GetShoppingBag());
      _bloc?.add(GetTotal());
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ClientShoppingBagBloc>(context);
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<ClientShoppingBagBloc, ClientShoppingBagState>(
            builder: (context, state) {
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  return ClientShoppingBagItem(_bloc, state, state.products[index]);
                },
              );
            },
          ),
          // 🌀 Overlay del loading
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 4,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<ClientShoppingBagBloc, ClientShoppingBagState>(
        builder: (context, state) {
          return ClientShoppingBagBottomBar(
            state,
            selectedOrderType: selectedOrderType,
            selectedAddressId: selectedAddressId,
            onConfirmOrder: () => _confirmOrder(context, state),
          );
        },
      ),
    );
  }

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
      onConfirm: () => _createOrder(context, state),
    );
  }

  Future<void> _createOrder(BuildContext context, ClientShoppingBagState state) async {
    setState(() => _isLoading = true); // ⏳ Mostrar loading

    try {
      final authResponse = await _bloc!.authUseCases.getUserSession.run();
      final clientId = authResponse!.cliente.id!;
      //final token = authResponse.token;

      final ordersService = OrdersService();

      List<Map<String, dynamic>> items = state.products.map((product) {
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
      );

      setState(() => _isLoading = false); // ⏹️ Ocultar loading

      if (response is Success<Order>) {
        final order = (response as Success<Order>).data;

        _bloc?.add(ClearShoppingBag());

        Navigator.pushNamed(
          context,
          'client/order/confirmation',
          arguments: order,
        );
      } else if (response is Error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear orden: ${(response as Error).message}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error desconocido al crear la orden')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
      );
    }
  }
}
