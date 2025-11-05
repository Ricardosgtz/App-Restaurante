import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Address.dart';
import 'package:flutter_application_1/src/presentation/utils/AlertHelper.dart';
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
  required Function(String?) onConfirm,
}) {
  String tempOrderType = selectedOrderType;
  int? tempAddressId = selectedAddressId;
  Address? tempSelectedAddress = selectedAddress;
  String tempNote = '';
  String? tempArrivalTime;
  String? displayTime;

  // 🎨 Usando el color del tema
  final Color primaryOrange = AppTheme.primaryColor;
  final Color lightOrange = AppTheme.primaryColor.withOpacity(0.8);
  final Color darkOrange = AppTheme.primaryColor.withOpacity(0.9);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder:
            (context, setState) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 40,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🎨 HEADER NARANJA CON GRADIENTE
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        gradient: LinearGradient(
                          colors: [lightOrange, primaryOrange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Icono de bolsa
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.shopping_bag,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tipo de Pedido',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Selecciona cómo recibirás tu pedido',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 📋 CONTENIDO
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔹 Opción "En el sitio"
                            _buildOrangeRadioOption(
                              context,
                              'sitio',
                              Icons.storefront_rounded,
                              'En el Sitio',
                              'Recoger en el restaurante',
                              tempOrderType,
                              (value) {
                                setState(() {
                                  tempOrderType = value;
                                  tempAddressId = null;
                                  tempSelectedAddress = null;
                                  tempArrivalTime = null;
                                  displayTime = null;
                                });
                              },
                            ),
                            const SizedBox(height: 14),

                            // 🔹 Opción "Anticipado"
                            _buildOrangeRadioOption(
                              context,
                              'anticipado',
                              Icons.access_time_rounded,
                              'Anticipado',
                              'Pedido para más tarde',
                              tempOrderType,
                              (value) {
                                setState(() {
                                  tempOrderType = value;
                                  tempAddressId = null;
                                  tempSelectedAddress = null;
                                  tempArrivalTime = null;
                                  displayTime = null;
                                });
                              },
                            ),
                            const SizedBox(height: 14),

                            // 🔹 Opción "Domicilio"
                            _buildOrangeRadioOption(
                              context,
                              'domicilio',
                              Icons.local_shipping_rounded,
                              'A Domicilio',
                              'Entrega en tu dirección',
                              tempOrderType,
                              (value) {
                                setState(() {
                                  tempOrderType = value;
                                  tempArrivalTime = null;
                                  displayTime = null;
                                });
                              },
                            ),

                            // 🏠 DIRECCIÓN (solo domicilio)
                            if (tempOrderType == 'domicilio') ...[
                              const SizedBox(height: 24),
                              Text(
                                'Dirección de entrega',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Contenedor de dirección
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color:
                                        tempAddressId != null
                                            ? primaryOrange
                                            : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_off_outlined,
                                      color: Colors.grey[400],
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (tempSelectedAddress != null) ...[
                                            Text(
                                              tempSelectedAddress!
                                                      .alias
                                                      .isNotEmpty
                                                  ? tempSelectedAddress!.alias
                                                  : 'Sin alias',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              tempSelectedAddress!.address,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Colors.grey[700],
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ] else
                                            Text(
                                              'No has seleccionado dirección',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Botón seleccionar dirección
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryOrange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        CupertinoIcons.location_solid,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        tempAddressId != null
                                            ? 'Cambiar Dirección'
                                            : 'Seleccionar Dirección',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            // 🕒 HORA DE LLEGADA (solo anticipado)
                            if (tempOrderType == 'anticipado') ...[
                              const SizedBox(height: 24),
                              Text(
                                'Hora de llegada',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 12),

                              GestureDetector(
                                onTap: () async {
                                  final TimeOfDay?
                                  picked = await showTimePicker(
                                    context: context,
                                    initialTime: const TimeOfDay(
                                      hour: 15,
                                      minute: 0,
                                    ),
                                    helpText: 'Selecciona hora de llegada (PM)',
                                    initialEntryMode: TimePickerEntryMode.dial,
                                    builder: (context, child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: false,
                                        ),
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme:
                                                ColorScheme.light(
                                                  primary: primaryOrange,
                                                  onPrimary: Colors.white,
                                                  onSurface: Colors.black87,
                                                ),
                                            timePickerTheme:
                                                TimePickerThemeData(
                                                  backgroundColor: Colors.white,
                                                  dialBackgroundColor:
                                                      Colors.grey.shade100,
                                                  dialHandColor: primaryOrange,
                                                  hourMinuteColor: primaryOrange
                                                      .withOpacity(0.1),
                                                  hourMinuteTextColor:
                                                      Colors.black,
                                                  dayPeriodColor: primaryOrange
                                                      .withOpacity(0.2),
                                                  dayPeriodTextColor:
                                                      primaryOrange,
                                                  entryModeIconColor:
                                                      primaryOrange,
                                                  helpTextStyle:
                                                      GoogleFonts.poppins(
                                                        color: primaryOrange,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                ),
                                          ),
                                          child: child!,
                                        ),
                                      );
                                    },
                                  );

                                  if (picked != null) {
                                    final int totalMinutes =
                                        picked.hour * 60 + picked.minute;
                                    const int startMinutes = 15 * 60;
                                    const int endMinutes = 23 * 60;

                                    if (totalMinutes < startMinutes ||
                                        totalMinutes > endMinutes) {
                                      await AlertHelper.showAlertDialog(
                                        context: context,
                                        title: 'Hora inválida',
                                        message:
                                            'Selecciona una hora entre las 15:00 PM y las 23:00 PM',
                                        isSuccess: false,
                                      );
                                      return;
                                    }

                                    final String display =
                                        '${picked.hourOfPeriod.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')} ${picked.period == DayPeriod.am ? "AM" : "PM"}';

                                    final String backend =
                                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';

                                    setState(() {
                                      displayTime = display;
                                      tempArrivalTime = backend;
                                    });

                                    await AlertHelper.showAlertDialog(
                                      context: context,
                                      title: 'Hora seleccionada',
                                      message:
                                          'Tu pedido anticipado será para las $display.',
                                      isSuccess: true,
                                    );
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color:
                                          displayTime != null
                                              ? primaryOrange
                                              : Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        color:
                                            displayTime != null
                                                ? primaryOrange
                                                : Colors.grey[400],
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          displayTime ??
                                              'Seleccionar hora (PM)',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                displayTime != null
                                                    ? Colors.black87
                                                    : Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.grey[400],
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Horario disponible: 15:00 - 23:00',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],

                            const SizedBox(height: 24),

                            // 📝 NOTA
                            Text(
                              'Nota para el pedido',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 12),

                            TextField(
                              onChanged: (value) {
                                tempNote = value;
                                onNoteChanged(value);
                              },
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Instrucciones especiales (opcional)',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                ),
                                prefixIcon: Icon(
                                  Icons.edit_note_rounded,
                                  color: primaryOrange,
                                  size: 24,
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: primaryOrange,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // ✅ BOTÓN CONFIRMAR
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (tempOrderType == 'domicilio' &&
                                      tempAddressId == null) {
                                    await AlertHelper.showAlertDialog(
                                      context: context,
                                      title: 'Dirección requerida',
                                      message:
                                          'Debes seleccionar una dirección para el pedido a domicilio',
                                      isSuccess: false,
                                    );
                                    return;
                                  }
                                  if (tempOrderType == 'anticipado' &&
                                      (tempArrivalTime == null ||
                                          tempArrivalTime!.isEmpty)) {
                                    await AlertHelper.showAlertDialog(
                                      context: context,
                                      title: 'Campo requerido',
                                      message:
                                          'Selecciona una hora válida antes de confirmar el pedido',
                                      isSuccess: false,
                                    );
                                    return;
                                  }

                                  onOrderTypeChanged(tempOrderType);
                                  onAddressSelected(tempAddressId);
                                  onAddressObjectSelected(tempSelectedAddress);
                                  onNoteChanged(tempNote);
                                  Navigator.pop(context);
                                  onConfirm(tempArrivalTime);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryOrange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.task_alt_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Confirma Tu Orden',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Botón cancelar
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: Text(
                                  'Cancelar',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
    },
  );
}

// 🔹 WIDGET DE OPCIÓN NARANJA
Widget _buildOrangeRadioOption(
  BuildContext context,
  String value,
  IconData icon,
  String title,
  String subtitle,
  String groupValue,
  Function(String) onChanged,
) {
  final bool isSelected = groupValue == value;
  final Color primaryOrange = AppTheme.primaryColor;

  return GestureDetector(
    onTap: () => onChanged(value),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isSelected ? primaryOrange.withOpacity(0.1) : Colors.white,
        border: Border.all(
          color: isSelected ? primaryOrange : Colors.grey.shade300,
          width: isSelected ? 2.5 : 1.5,
        ),
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: primaryOrange.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
                : [],
      ),
      child: Row(
        children: [
          // Icono con fondo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? primaryOrange.withOpacity(0.2)
                      : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? primaryOrange : Colors.grey[600],
              size: 28,
            ),
          ),
          const SizedBox(width: 16),

          // Texto con título y subtítulo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.black87 : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Check icon
          if (isSelected)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: primaryOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 18),
            ),
        ],
      ),
    ),
  );
}