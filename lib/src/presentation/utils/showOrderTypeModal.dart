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
  required Function(String) onNoteChanged, // 🆕 NUEVO
  required Function() onConfirm,
}) {
  String tempOrderType = selectedOrderType;
  int? tempAddressId = selectedAddressId;
  Address? tempSelectedAddress = selectedAddress;
  String tempNote = ''; // 🆕 Variable para la nota

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Center(
            child: Text(
              'Tipo de Pedido',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🟩 Radio: En el Sitio
                _buildRadioOption(
                  context,
                  'sitio',
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

                // 🟩 Radio: Anticipado
                _buildRadioOption(
                  context,
                  'anticipado',
                  'Anticipado',
                  'Para una hora específica',
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

                // 🟩 Radio: A Domicilio
                _buildRadioOption(
                  context,
                  'domicilio',
                  'A Domicilio',
                  'Entrega en tu dirección',
                  tempOrderType,
                  (value) {
                    setState(() {
                      tempOrderType = value;
                    });
                  },
                ),

                // 🟦 Campo de dirección (solo si el tipo es domicilio)
                if (tempOrderType == 'domicilio')
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Dirección de entrega',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: tempAddressId != null
                                  ? AppTheme.primaryColor
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                            color: tempAddressId != null
                                ? AppTheme.primaryColor.withOpacity(0.05)
                                : Colors.grey[50],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (tempSelectedAddress != null) ...[
                                Text(
                                  tempSelectedAddress!.alias.isNotEmpty
                                      ? tempSelectedAddress!.alias
                                      : "Sin alias",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
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
                                const SizedBox(height: 2),
                                Text(
                                  tempSelectedAddress!.reference,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ] else
                                Text(
                                  'No has seleccionado dirección',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
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
                          icon: const Icon(Icons.location_on),
                          label: Text(
                            tempAddressId != null
                                ? 'Cambiar Dirección'
                                : 'Seleccionar Dirección',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                // 📝 Campo de texto para nota (aparece para todos los tipos)
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    tempNote = value;
                    onNoteChanged(value); // Notifica al padre
                  },
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Nota para el pedido (opcional)',
                    labelStyle: GoogleFonts.poppins(fontSize: 13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (tempOrderType == 'domicilio' && tempAddressId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Debes seleccionar una dirección'),
                    ),
                  );
                  return;
                }

                // 🔄 Devolver resultados al padre
                onOrderTypeChanged(tempOrderType);
                onAddressSelected(tempAddressId);
                onAddressObjectSelected(tempSelectedAddress);
                onNoteChanged(tempNote);

                Navigator.pop(context);
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: Text(
                'Confirmar',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildRadioOption(
  BuildContext context,
  String value,
  String title,
  String subtitle,
  String groupValue,
  Function(String) onChanged,
) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: groupValue == value ? AppTheme.primaryColor : Colors.grey[300]!,
        width: groupValue == value ? 2 : 1,
      ),
      color: groupValue == value
          ? AppTheme.primaryColor.withOpacity(0.05)
          : Colors.white,
    ),
    child: RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      onChanged: (newValue) => onChanged(newValue!),
      activeColor: AppTheme.primaryColor,
    ),
  );
}
