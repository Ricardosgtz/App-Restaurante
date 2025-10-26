import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListState.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientAddressListItem extends StatelessWidget {
  final ClientAddressListBloc? bloc;
  final ClientAddressListState state;
  final Address address;
  final int index;

  const ClientAddressListItem(
    this.bloc,
    this.state,
    this.address,
    this.index, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = state.radioValue == index;
    final primary = AppTheme.primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          bloc?.add(ChangeRadioValue(radioValue: index, address: address));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? primary : Colors.white, // 🔥 cambia color al seleccionar
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 55, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🏷️ Contenido de texto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Alias
                          Text(
                            address.alias.isNotEmpty
                                ? address.alias
                                : "Sin alias",
                            style: GoogleFonts.poppins(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),

                          // Dirección
                          Text(
                            address.address,
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              color:
                                  isSelected ? Colors.white : Colors.grey[800],
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),

                          // Referencia
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.map_pin_ellipse,
                                size: 14,
                                color:
                                    isSelected ? Colors.white70 : Colors.grey[600],
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  address.reference.isNotEmpty
                                      ? address.reference
                                      : "Sin referencia",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.3,
                                    color: isSelected
                                        ? Colors.white70
                                        : Colors.grey.shade600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 🗑️ Botón eliminar (siempre visible)
              Positioned(
                bottom: 8,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    bloc?.add(DeleteAddress(id: address.id!, context: context));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Colors.white.withOpacity(0.25)
                          : Colors.redAccent.withOpacity(0.15),
                    ),
                    child: Icon(
                      CupertinoIcons.trash_fill,
                      color: isSelected
                          ? Colors.white
                          : Colors.redAccent,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
