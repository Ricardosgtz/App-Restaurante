// lib/src/presentation/pages/client/order/list/ClientOrderListItem.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/models/Payment.dart';
import 'package:flutter_application_1/src/domain/useCases/payments/PaymentsUseCases.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/injection.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ClientOrderListItem extends StatefulWidget {
  final Order order;

  const ClientOrderListItem(this.order, {super.key});

  @override
  State<ClientOrderListItem> createState() => _ClientOrderListItemState();
}

class _ClientOrderListItemState extends State<ClientOrderListItem> {
  Payment? _payment;
  bool _isLoadingPayment = true;
  PaymentsUseCases paymentsUseCases = locator<PaymentsUseCases>();

  @override
  void initState() {
    super.initState();
    _loadPayment();
  }

  /// ✅ Este método se ejecuta si Flutter reutiliza el mismo widget para otra orden
  @override
  void didUpdateWidget(covariant ClientOrderListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.order.id != widget.order.id) {
      // 🔄 Reiniciar el estado del pago cuando cambia la orden
      setState(() {
        _payment = null;
        _isLoadingPayment = true;
      });
      _loadPayment();
    }
  }

  Future<void> _loadPayment() async {
    if (!mounted) return;
    try {
      final result = await paymentsUseCases.getPaymentByOrderId.run(
        orderId: widget.order.id,
        context: context,
      );

      if (!mounted) return;

      setState(() {
        if (result is Success<Payment?>) {
          _payment = result.data;
        }
        _isLoadingPayment = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingPayment = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'd MMM yyyy, h:mm a',
      'es_MX',
    ).format(widget.order.createdAt);

    // 🎨 Colores e íconos según estado del PEDIDO
    final Map<String, Map<String, dynamic>> statusMap = {
      'pendiente': {'color': Colors.orangeAccent, 'icon': Icons.schedule},
      'confirmada': {
        'color': Colors.blueAccent,
        'icon': Icons.verified_rounded,
      },
      'en proceso': {'color': Colors.amber, 'icon': Icons.coffee_rounded},
      'enviada': {
        'color': Colors.deepPurpleAccent,
        'icon': Icons.local_shipping,
      },
      'entregada': {'color': Colors.green, 'icon': Icons.check_circle},
      'cancelada': {'color': Colors.redAccent, 'icon': Icons.cancel},
    };

    final color =
        statusMap[widget.order.status.name.toLowerCase()]?['color'] ??
        Colors.grey;
    final icon =
        statusMap[widget.order.status.name.toLowerCase()]?['icon'] ??
        Icons.help_outline_rounded;

    return GestureDetector(
      onTap:
          () => Navigator.pushNamed(
            context,
            'client/order/detail',
            arguments: widget.order,
          ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        // 🟧 Franja lateral + contenido
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              // 🟩 Franja lateral degradada
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 6,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(22),
                      bottomLeft: Radius.circular(22),
                    ),
                  ),
                ),
              ),

              // 📦 Contenido principal
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🧾 Header — Pedido + Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(icon, color: color, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Pedido #${widget.order.id}',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        // 💰 Total
                        Text(
                          '\$${widget.order.total.toStringAsFixed(2)}',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            color: color,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Divider(color: Colors.grey[200], thickness: 1),
                    const SizedBox(height: 10),

                    // 🏪 Restaurante
                    Row(
                      children: [
                        const Icon(
                          Icons.storefront_rounded,
                          size: 18,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.order.restaurant.name,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // 📍 Dirección
                    if (widget.order.address != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.order.address!.address,
                              style: GoogleFonts.outfit(
                                fontSize: 13.5,
                                color: Colors.grey[700],
                                height: 1.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 6),

                    // 📅 Fecha
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 16,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formattedDate,
                          style: GoogleFonts.outfit(
                            fontSize: 13.5,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // 🏷️ ESTADOS: Pedido y Pago
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Estado del PEDIDO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pedido:',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: color.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(icon, size: 15, color: color),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        widget.order.status.name,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.5,
                                          color: color,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Estado del PAGO (clickeable)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pago:',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (_isLoadingPayment)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Cargando...',
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.5,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else if (_payment != null)
                                GestureDetector(
                                  onTap: () {
                                    _showPaymentDetailsModal(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getPaymentStatusColor(
                                        _payment!.status,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: _getPaymentStatusColor(
                                          _payment!.status,
                                        ).withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _getPaymentStatusIcon(_payment!.status),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            _getPaymentStatusText(
                                              _payment!.status,
                                            ),
                                            style: GoogleFonts.outfit(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.5,
                                              color: _getPaymentStatusColor(
                                                _payment!.status,
                                              ),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.credit_card,
                                          size: 14,
                                          color: _getPaymentStatusColor(
                                            _payment!.status,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.help_outline,
                                        size: 15,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          'Sin pago',
                                          style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.5,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
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
      ),
    );
  }

  // 🎨 Método para obtener el color según el estado del pago
  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'confirmado':
        return Colors.green;
      case 'rechazado':
        return Colors.red;
      case 'reembolso':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // 🎨 Método para obtener el icono según el estado del pago
  Widget _getPaymentStatusIcon(String status) {
    IconData iconData;
    Color iconColor = _getPaymentStatusColor(status);

    switch (status.toLowerCase()) {
      case 'pendiente':
        iconData = Icons.hourglass_bottom_rounded;
        break;
      case 'confirmado':
        iconData = Icons.check_circle_rounded;
        break;
      case 'rechazado':
        iconData = Icons.cancel_rounded;
        break;
      case 'reembolso':
        iconData = Icons.attach_money_rounded;
        break;
      default:
        iconData = Icons.help_outline_rounded;
    }

    return Icon(iconData, size: 15, color: iconColor);
  }

  // 📝 Método para obtener el texto según el estado del pago
  String _getPaymentStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return 'Pendiente';
      case 'confirmado':
        return 'Confirmado';
      case 'rechazado':
        return 'Rechazado';
      case 'reembolso':
        return 'Reembolso';
      default:
        return status;
    }
  }

  // 📋 Modal de detalles del pago
  void _showPaymentDetailsModal(BuildContext context) {
    if (_payment == null) return;

    final formattedDate = DateFormat(
      'd MMM yyyy, h:mm a',
      'es_MX',
    ).format(DateTime.parse(_payment!.paymentDate));

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🎨 Header con icono
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.credit_card,
                      color: AppTheme.primaryColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Detalles del Pago',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Pedido #${widget.order.id}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 16),

                  // 💳 Método de pago
                  _buildDetailRow(
                    Icons.payment_rounded,
                    'Método de pago',
                    _payment!.paymentMethod == 'efectivo'
                        ? 'Efectivo'
                        : 'Transferencia',
                  ),
                  const SizedBox(height: 16),

                  // 📊 Estado
                  _buildDetailRow(
                    Icons.info_outline_rounded,
                    'Estado',
                    _getPaymentStatusText(_payment!.status),
                    valueColor: _getPaymentStatusColor(_payment!.status),
                  ),
                  const SizedBox(height: 16),

                  // 💰 Monto
                  _buildDetailRow(
                    Icons.attach_money_rounded,
                    'Monto',
                    '\$${_payment!.amount.toStringAsFixed(2)}',
                    valueColor: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),

                  // 📅 Fecha
                  _buildDetailRow(
                    Icons.calendar_today_rounded,
                    'Fecha',
                    formattedDate,
                  ),

                  // 📄 Comprobante (solo si es transferencia y hay comprobante)
                  if (_payment!.paymentMethod.toLowerCase() ==
                          'transferencia' &&
                      _payment!.receipt != null &&
                      _payment!.receipt!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.receipt_long_rounded,
                      'Comprobante',
                      'Ver imagen',
                      onTap: () {
                        _showReceiptImage(context, _payment!.receipt!);
                      },
                    ),
                  ],

                  const SizedBox(height: 20),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 16),

                  // ℹ️ Mensaje informativo según el estado
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getPaymentStatusColor(
                        _payment!.status,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: _getPaymentStatusColor(_payment!.status),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _getPaymentInfoMessage(_payment!),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🔘 Botón cerrar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cerrar',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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

  // Widget para las filas de detalles
  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.grey[700]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.black87,
                    decoration: onTap != null ? TextDecoration.underline : null,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }

  // Mensaje informativo según el estado del pago
  String _getPaymentInfoMessage(Payment payment) {
    switch (payment.status.toLowerCase()) {
      case 'pendiente':
        if (payment.paymentMethod.toLowerCase() == 'efectivo') {
          return 'Pagarás en efectivo al recoger tu pedido en el restaurante.';
        } else {
          return 'Tu comprobante está siendo revisado por el restaurante. Te notificaremos cuando sea confirmado.';
        }
      case 'confirmado':
        return 'Tu pago ha sido confirmado exitosamente. ¡Gracias por tu compra!';
      case 'rechazado':
        return 'Tu pago fue rechazado. Por favor, contacta con el restaurante para más información.';
      case 'reembolso':
        return 'Se ha procesado un reembolso para este pedido. El dinero será devuelto según el método de pago original.';
      default:
        return '';
    }
  }

  // Mostrar imagen del comprobante
  void _showReceiptImage(BuildContext context, String receiptUrl) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      receiptUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No se pudo cargar la imagen',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.close, size: 24),
                ),
              ],
            ),
          ),
    );
  }
}
