import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/PaymentsService.dart';
import 'package:flutter_application_1/src/domain/models/Payment.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/utils/AlertHelper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

/// 💳 Modal elegante centrado para seleccionar método de pago
void showPaymentMethodModal(
  BuildContext context,
  int orderId,
  double total,
  Restaurant restaurant, {
  required VoidCallback onPaymentSuccess,
}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Método de pago",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (_, __, ___) => const SizedBox(),
    transitionBuilder: (context, animation, _, child) {
      final curvedValue = Curves.easeOutCubic.transform(animation.value);
      return Transform.scale(
        scale: 0.8 + (0.2 * curvedValue),
        child: Opacity(
          opacity: animation.value,
          child: _ModernPaymentDialog(
            orderId: orderId,
            total: total,
            restaurant: restaurant,
            onPaymentSuccess: onPaymentSuccess,
          ),
        ),
      );
    },
  );
}

class _ModernPaymentDialog extends StatefulWidget {
  final int orderId;
  final double total;
  final Restaurant restaurant;
  final VoidCallback onPaymentSuccess;

  const _ModernPaymentDialog({
    required this.orderId,
    required this.total,
    required this.restaurant,
    required this.onPaymentSuccess,
  });

  @override
  State<_ModernPaymentDialog> createState() => _ModernPaymentDialogState();
}

class _ModernPaymentDialogState extends State<_ModernPaymentDialog>
    with SingleTickerProviderStateMixin {
  String selectedMethod = 'efectivo';
  File? comprobanteFile;
  bool _isLoading = false;
  late AnimationController _animController;

  final PaymentsService _service = PaymentsService();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => comprobanteFile = File(picked.path));
      _animController.forward();
    }
  }

  Future<void> _confirmPayment() async {
    // Validar que si es transferencia tenga comprobante
    if (selectedMethod == 'transferencia' && comprobanteFile == null) {
      AlertHelper.showAlertDialog(
        context: context,
        title: 'Comprobante requerido',
        message: 'Por favor sube el comprobante de pago para continuar.',
        isSuccess: false,
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await _service.createPayment(
      orderId: widget.orderId,
      paymentMethod: selectedMethod,
      comprobantePath: comprobanteFile?.path,
      context: context,
    );

    setState(() => _isLoading = false);

    if (result is Success<Payment>) {
      Navigator.pop(context);
      AlertHelper.showAlertDialog(
        context: context,
        title: 'Pago registrado',
        message: 'Tu pago fue procesado correctamente.',
        isSuccess: true,
        onClose: widget.onPaymentSuccess,
      );
    } else if (result is Error) {
      final error = result as Error;
      AlertHelper.showAlertDialog(
        context: context,
        title: 'Error',
        message: error.message ?? 'Ocurrió un error al registrar el pago.',
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = AppTheme.primaryColor;
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: size.height * 0.85,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.2),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🎨 Header con gradiente
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accent, accent.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.payment_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Método de Pago',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Selecciona cómo deseas pagar',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // 📄 Contenido principal
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // 💰 Total a pagar destacado
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: accent.withOpacity(0.15),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total a pagar',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${widget.total.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: accent,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'MXN',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 🎯 Métodos de pago como tarjetas
                      Text(
                        'Elige tu método de pago',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 💵 Efectivo
                      _PaymentMethodCard(
                        icon: Icons.money_rounded,
                        title: 'Efectivo',
                        subtitle: 'Paga al recibir tu pedido',
                        isSelected: selectedMethod == 'efectivo',
                        accentColor: accent,
                        onTap: () {
                          setState(() => selectedMethod = 'efectivo');
                          _animController.reset();
                        },
                      ),

                      const SizedBox(height: 12),

                      // 🏦 Transferencia
                      _PaymentMethodCard(
                        icon: Icons.account_balance_rounded,
                        title: 'Transferencia',
                        subtitle: 'Pago por transferencia bancaria',
                        isSelected: selectedMethod == 'transferencia',
                        accentColor: accent,
                        onTap: () {
                          setState(() => selectedMethod = 'transferencia');
                          _animController.reset();
                        },
                      ),

                      // 🏦 Detalles bancarios (solo si es transferencia)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child:
                            selectedMethod == 'transferencia'
                                ? Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    _BankDetailsSection(
                                      restaurant: widget.restaurant,
                                      accentColor: accent,
                                    ),
                                    const SizedBox(height: 20),
                                    _UploadReceiptSection(
                                      comprobanteFile: comprobanteFile,
                                      accentColor: accent,
                                      onPickImage: _pickImage,
                                      onRemove: () {
                                        setState(() => comprobanteFile = null);
                                        _animController.reverse();
                                      },
                                      animation: _animController,
                                    ),
                                  ],
                                )
                                : const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 28),

                      // 🟢 Botón Confirmar
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _confirmPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            disabledBackgroundColor: accent.withOpacity(0.6),
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                  : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Confirmar Pago',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ❌ Botón Cancelar
                      TextButton(
                        onPressed:
                            _isLoading ? null : () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
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
  }
}

// 🎴 Tarjeta de método de pago
class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.08) : Colors.grey[50],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? accentColor : Colors.grey[300]!,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: accentColor.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          children: [
            // Ícono
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? accentColor.withOpacity(0.15)
                        : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? accentColor : Colors.grey[600],
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? accentColor : Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Check animado
            AnimatedScale(
              scale: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.elasticOut,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🏦 Sección de detalles bancarios
class _BankDetailsSection extends StatelessWidget {
  final Restaurant restaurant;
  final Color accentColor;

  const _BankDetailsSection({
    required this.restaurant,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withOpacity(0.08),
            accentColor.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  restaurant.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _BankInfoRow(
            label: 'Número de cuenta',
            value: restaurant.accountNumber ?? '—',
            accentColor: accentColor,
          ),
          const SizedBox(height: 12),
          _BankInfoRow(
            label: 'CLABE interbancaria',
            value: restaurant.clabe ?? '—',
            accentColor: accentColor,
          ),
        ],
      ),
    );
  }
}

// 📋 Fila de información bancaria con copiar
class _BankInfoRow extends StatefulWidget {
  final String label;
  final String value;
  final Color accentColor;

  const _BankInfoRow({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  State<_BankInfoRow> createState() => _BankInfoRowState();
}

class _BankInfoRowState extends State<_BankInfoRow> {
  bool _copied = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.value));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.value,
                  style: GoogleFonts.robotoMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _copyToClipboard,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color:
                        _copied
                            ? Colors.green.withOpacity(0.1)
                            : widget.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _copied ? Icons.check_rounded : Icons.copy_rounded,
                    size: 16,
                    color: _copied ? Colors.green : widget.accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 📤 Sección de subir comprobante
class _UploadReceiptSection extends StatelessWidget {
  final File? comprobanteFile;
  final Color accentColor;
  final VoidCallback onPickImage;
  final VoidCallback onRemove;
  final AnimationController animation;

  const _UploadReceiptSection({
    required this.comprobanteFile,
    required this.accentColor,
    required this.onPickImage,
    required this.onRemove,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comprobante de pago',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),

        if (comprobanteFile == null)
          // Botón para subir
          GestureDetector(
            onTap: onPickImage,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accentColor.withOpacity(0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_upload_rounded,
                      color: accentColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Subir comprobante',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Toca para seleccionar imagen',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          // Preview del comprobante
          FadeTransition(
            opacity: animation,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          comprobanteFile!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.green,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Comprobante cargado',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[900],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Listo para enviar',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Botones abajo
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onPickImage,
                          icon: Icon(
                            Icons.edit_rounded,
                            size: 18,
                            color: accentColor,
                          ),
                          label: Text(
                            'Cambiar',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: accentColor,
                            side: BorderSide(
                              color: accentColor.withOpacity(0.3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onRemove,
                          icon: const Icon(
                            Icons.delete_rounded,
                            size: 18,
                            color: Colors.red,
                          ),
                          label: Text(
                            'Eliminar',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(
                              color: Colors.red.withOpacity(0.3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
