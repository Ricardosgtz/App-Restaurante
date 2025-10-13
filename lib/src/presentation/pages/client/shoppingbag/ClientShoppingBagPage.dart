import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';
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
  Address? selectedAddress;
  

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
      appBar: HomeAppBar(title: 'Mi Orden'),
      body: BlocBuilder<ClientShoppingBagBloc, ClientShoppingBagState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              return ClientShoppingBagItem(_bloc, state, state.products[index]);
            },
          );
        },
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
    // Validar que haya productos
    if (state.products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes agregar al menos un producto')),
      );
      return;
    }

    // Mostrar el modal
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
      onConfirm: () => _createOrder(context, state),
    );
  }

  void _createOrder(BuildContext context, ClientShoppingBagState state) {
    // Preparar items para enviar
    List<Map<String, dynamic>> items = state.products.map((product) {
      return {
        'product_id': product.id,
        'quantity': product.quantity,
        'unit_price': product.price,
      };
    }).toList();

    // Navegar a confirmación con los datos
    Navigator.pushNamed(
      context,
      'client/order/confirmation',
      arguments: {
        'orderType': selectedOrderType,
        'addressId': selectedAddressId,
        'items': items,
        'total': state.total,
      },
    );
  }
}