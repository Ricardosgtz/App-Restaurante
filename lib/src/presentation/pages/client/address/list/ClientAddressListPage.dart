import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeAppBar.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/ClientAddressListItem.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClientAddressListPage extends StatefulWidget {
  const ClientAddressListPage({super.key});

  @override
  State<ClientAddressListPage> createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {
  ClientAddressListBloc? _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc?.add(GetUserAddress());
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ClientAddressListBloc>(context);
    return Scaffold(
      appBar: HomeAppBar(title: 'Mis Direcciones'),

      // 🔹 FloatingActionButton con efecto Glass
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(
                0.6,
              ), // 💠 Color translúcido
              border: Border.all(color: Colors.white.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(-3, -3),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, 'client/address/create');
              },
              backgroundColor: Colors.transparent, // mantiene efecto vidrio
              elevation: 0,
              child: const Icon(
                CupertinoIcons.add, // 💎 Ícono Cupertino elegante
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
      ),

      body: BlocListener<ClientAddressListBloc, ClientAddressListState>(
        listener: (context, state) {
          final responseState = state.response;
          if (responseState is Success) {
            if (responseState.data is bool) {
              _bloc?.add(GetUserAddress());
            }
          }
          if (responseState is Error) {
            Fluttertoast.showToast(
              msg: responseState.message,
              toastLength: Toast.LENGTH_LONG,
            );
          }
        },
        child: BlocBuilder<ClientAddressListBloc, ClientAddressListState>(
          builder: (context, state) {
            final responseState = state.response;
            if (responseState is Success) {
              List<Address> address = responseState.data as List<Address>;
              _bloc?.add(SetAddressSession(addressList: address));
              return ListView.builder(
                itemCount: address.length,
                itemBuilder: (context, index) {
                  return ClientAddressListItem(
                    _bloc,
                    state,
                    address[index],
                    index,
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
