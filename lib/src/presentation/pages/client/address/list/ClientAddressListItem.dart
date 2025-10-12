import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListState.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientAddressListItem extends StatelessWidget {
  final ClientAddressListBloc? bloc;
  final ClientAddressListState state;
  final Address address;
  final int index;

  const ClientAddressListItem(this.bloc, this.state, this.address, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: IntrinsicHeight( // ⚡ Ajusta altura de la fila según el contenido más alto
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, // ⚡ Hace que el panel derecho tome toda la altura
            children: [
              // 👉 Parte izquierda clickable (alias + dirección + referencia)
              Expanded(
                flex: 3,
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  onTap: () {
                    bloc?.add(ChangeRadioValue(radioValue: index, address: address));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Alias
                        Text(
                          address.alias.isNotEmpty ? address.alias : "Sin alias",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Dirección
                        Text(
                          address.address,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Referencia con icono
                        Row(
                          children: [
                            const Icon(CupertinoIcons.location_solid, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                address.reference,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 👉 Panel derecho con radio y eliminar
              Container(
                width: 90,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      value: index,
                      groupValue: state.radioValue,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (value) {
                        bloc?.add(ChangeRadioValue(radioValue: value!, address: address));
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        bloc?.add(DeleteAddress(id: address.id!));
                      },
                      icon: const Icon(CupertinoIcons.trash, color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
