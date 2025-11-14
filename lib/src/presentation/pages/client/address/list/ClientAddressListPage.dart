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
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
      _bloc?.add(GetUserAddress(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ClientAddressListBloc>(context);
    final bool isSelectionMode =
        ModalRoute.of(context)?.settings.arguments == true;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: HomeAppBar(title: 'Mis Direcciones'),
      floatingActionButton: !isSelectionMode ? _buildAddButton(context) : null,
      body: BlocListener<ClientAddressListBloc, ClientAddressListState>(
        listener: (context, state) {
          final responseState = state.response;
          if (responseState is Success && responseState.data is bool) {
            _bloc?.add(GetUserAddress(context));
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

            // Mostrar loading solo cuando realmente está cargando
            if (responseState is Loading) {
              return const Center(
                child: SpinKitThreeBounce(
                  color: Colors.orange,
                  size: 30,
                  duration: Duration(seconds: 1),
                ),
              );
            }

            // Si hay un error real, mostrarlo
            if (responseState is Error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 60),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar direcciones',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        responseState.message,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _bloc?.add(GetUserAddress(context));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Si es Success, procesar las direcciones
            if (responseState is Success) {
              List<Address> addresses = responseState.data as List<Address>;
              if (addresses.isNotEmpty) {
                _bloc?.add(SetAddressSession(addressList: addresses));
              }
              // Si no hay direcciones, mostrar estado vacío
              if (addresses.isEmpty) {
                return _buildEmptyState(context, isSelectionMode);
              }

              // Si hay direcciones, mostrar la lista
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
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

                  // Botones tipo píldora (pill-shaped)
                  if (isSelectionMode)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          // Botón Confirmar
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryColor.withOpacity(0.95),
                                    AppTheme.primaryColor.withOpacity(0.8),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(
                                      0.35,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
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
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Confirmar',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Botón Agregar
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  'client/address/create',
                                );
                              },
                              icon: Icon(
                                Icons.add_location_alt_rounded,
                                size: 20,
                                color: AppTheme.primaryColor,
                              ),
                              label: Text(
                                'Agregar',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryColor,
                                side: BorderSide(
                                  color: AppTheme.primaryColor,
                                  width: 1.5,
                                ),
                                backgroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                shadowColor: Colors.grey.withOpacity(0.2),
                                elevation: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }

            // Estado inicial (antes de cargar) - Mostrar estado vacío
            return _buildEmptyState(context, isSelectionMode);
          },
        ),
      ),
    );
  }

  // Estado vacío elegante - MODIFICADO PARA SOPORTAR MODO SELECCIÓN
  Widget _buildEmptyState(BuildContext context, bool isSelectionMode) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.map_pin_ellipse,
                    color: AppTheme.primaryColor.withOpacity(0.8),
                    size: 70,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Aún no tienes direcciones guardadas',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Agrega una dirección para poder recibir tus pedidos fácilmente.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  // 🔥 Botón centrado cuando NO está en modo selección
                  if (!isSelectionMode)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, 'client/address/create');
                      },
                      icon: const Icon(
                        Icons.add_location_alt_rounded,
                        size: 20,
                      ),
                      label: Text(
                        'Agregar dirección',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 6,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // BOTÓN DE AGREGAR EN MODO SELECCIÓN (cuando no hay direcciones)
        if (isSelectionMode)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, 'client/address/create');
              },
              icon: Icon(
                Icons.add_location_alt_rounded,
                size: 20,
                color: AppTheme.primaryColor,
              ),
              label: Text(
                'Agregar dirección',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                  letterSpacing: 0.4,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor, width: 1.5),
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadowColor: Colors.grey.withOpacity(0.2),
                elevation: 2,
              ),
            ),
          ),
      ],
    );
  }

  // Botón flotante con efecto glass
  Widget _buildAddButton(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.7),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
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
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
