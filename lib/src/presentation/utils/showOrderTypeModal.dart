import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:google_fonts/google_fonts.dart';

void showOrderTypeModal(
  BuildContext context,
  Address? selectedAddress, {
  required String selectedOrderType,
  required int? selectedAddressId,
  required Function(String) onOrderTypeChanged,
  required Function(int?) onAddressSelected,
  required Function(Address?) onAddressObjectSelected,
  required Function(String) onNoteChanged,
  required Function() onConfirm,
}) {
  String tempOrderType = selectedOrderType;
  int? tempAddressId = selectedAddressId;
  Address? tempSelectedAddress = selectedAddress;
  String tempNote = '';

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.95),
                      Colors.grey.shade100.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🏷️ Título
                      Text(
                        'Tipo de Pedido',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 🍽️ En el sitio
                      _buildModernRadioOption(
                        context,
                        'sitio',
                        Icons.storefront_rounded, // 🧭
                        'En el Sitio',
                        'Recoger en el restaurante',
                        tempOrderType,
                        (value) {
                          setState(() {
                            tempOrderType = value;
                            tempAddressId = null;
                            tempSelectedAddress = null;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      // ⏰ Anticipado
                      _buildModernRadioOption(
                        context,
                        'anticipado',
                        Icons.alarm, // ⏰
                        'Anticipado',
                        'Pedido para más tarde',
                        tempOrderType,
                        (value) {
                          setState(() {
                            tempOrderType = value;
                            tempAddressId = null;
                            tempSelectedAddress = null;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      // 🏠 Domicilio
                      _buildModernRadioOption(
                        context,
                        'domicilio',
                        Icons.local_shipping, // 🚗
                        'A Domicilio',
                        'Entrega en tu dirección',
                        tempOrderType,
                        (value) {
                          setState(() {
                            tempOrderType = value;
                          });
                        },
                      ),

                      // 🏡 Dirección
                      if (tempOrderType == 'domicilio') ...[
                        const SizedBox(height: 18),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Dirección de entrega',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: tempAddressId != null
                                  ? AppTheme.primaryColor
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (tempSelectedAddress != null) ...[
                                Text(
                                  tempSelectedAddress!.alias.isNotEmpty
                                      ? tempSelectedAddress!.alias
                                      : 'Sin alias',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tempSelectedAddress!.address,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  tempSelectedAddress!.reference,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ] else
                                Text(
                                  'No has seleccionado dirección',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              'client/address/list',
                              arguments: true,
                            );

                            if (result != null && result is Address) {
                              setState(() {
                                tempAddressId = result.id;
                                tempSelectedAddress = result;
                              });
                              onAddressObjectSelected(result);
                              onAddressSelected(result.id);
                            }
                          },
                          icon: const Icon(CupertinoIcons.location_solid),
                          label: Text(
                            tempAddressId != null
                                ? 'Cambiar Dirección'
                                : 'Seleccionar Dirección',
                            style:
                                GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // 📝 Nota
                      TextField(
                        onChanged: (value) {
                          tempNote = value;
                          onNoteChanged(value);
                        },
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Nota para el pedido (opcional)',
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 13.5,
                            color: Colors.grey[700],
                          ),
                          prefixIcon:
                              const Icon(Icons.edit_note_outlined),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: AppTheme.primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ✅ Botones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () => Navigator.pop(context),
                            label: Text(
                              'Cancelar',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (tempOrderType == 'domicilio' &&
                                  tempAddressId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Debes seleccionar una dirección'),
                                  ),
                                );
                                return;
                              }
                              onOrderTypeChanged(tempOrderType);
                              onAddressSelected(tempAddressId);
                              onAddressObjectSelected(tempSelectedAddress);
                              onNoteChanged(tempNote);
                              Navigator.pop(context);
                              onConfirm();
                            },
                            label: Text(
                              'Confirmar',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 5,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

// 🔹 RADIO PERSONALIZADO CON ÍCONO Y ESTILO MODERNO
Widget _buildModernRadioOption(
  BuildContext context,
  String value,
  IconData icon,
  String title,
  String subtitle,
  String groupValue,
  Function(String) onChanged,
) {
  final bool isSelected = groupValue == value;

  return AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
        width: isSelected ? 2 : 1,
      ),
      color: isSelected
          ? AppTheme.primaryColor.withOpacity(0.08)
          : Colors.white,
      boxShadow: [
        if (isSelected)
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
      ],
    ),
    child: RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      contentPadding: const EdgeInsets.all(0),
      activeColor: AppTheme.primaryColor,
      onChanged: (newValue) => onChanged(newValue!),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor.withOpacity(0.15)
                  : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: isSelected
                    ? AppTheme.primaryColor
                    : Colors.grey.shade600,
                size: 22),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
