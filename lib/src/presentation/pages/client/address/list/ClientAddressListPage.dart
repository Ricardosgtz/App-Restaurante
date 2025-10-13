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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc?.add(GetUserAddress());
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ClientAddressListBloc>(context);

    // ⚡ Detecta si la página se abrió en modo selección (desde el modal)
    final bool isSelectionMode =
        ModalRoute.of(context)?.settings.arguments == true;

    return Scaffold(
      appBar: HomeAppBar(title: 'Mis Direcciones'),

      // ✅ Solo muestra el botón flotante si NO está en modo selección
      floatingActionButton: !isSelectionMode ? _buildAddButton(context) : null,

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
              List<Address> addresses = responseState.data as List<Address>;
              _bloc?.add(SetAddressSession(addressList: addresses));

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        return ClientAddressListItem(
                          _bloc,
                          state,
                          addresses[index],
                          index,
                        );
                      },
                    ),
                  ),

                  // ✅ Solo muestra estos botones si se abrió en modo selección
                  if (isSelectionMode)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          // 🟩 Botón Confirmar
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (state.addressSelected != null) {
                                  Navigator.pop(
                                    context,
                                    state.addressSelected!,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Selecciona una dirección primero',
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.check_circle_outline,
                                size: 18,
                              ),
                              label: const Text(
                                'Confirmar',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ), // Espacio entre los botones
                          // ⬜️ Botón Agregar nueva dirección
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  'client/address/create',
                                );
                              },
                              icon: const Icon(
                                Icons.add_location_alt_outlined,
                                size: 18,
                              ),
                              label: const Text(
                                'Agregar',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryColor,
                                side: BorderSide(
                                  color: AppTheme.primaryColor,
                                  width: 1.3,
                                ),
                                minimumSize: const Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  // 🔹 Botón flotante con efecto glass (solo modo normal)
  Widget _buildAddButton(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.6),
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(
              CupertinoIcons.add,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }
}
