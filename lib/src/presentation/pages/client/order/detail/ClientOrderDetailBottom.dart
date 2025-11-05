import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Widget que muestra el panel inferior con los detalles de la orden
/// Incluye: fecha, dirección, estado y total
class ClientOrderDetailBottom extends StatelessWidget {
  final Order? order;

  const ClientOrderDetailBottom(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    if (order == null) return const SizedBox();

    final formattedDate =
        DateFormat('d MMM yyyy, h:mm a', 'es_MX').format(order!.createdAt);

    final statusInfo = _getStatusInfo(order!.status.name.toLowerCase());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: _buildContainerDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          const SizedBox(height: 16),
          
          _buildInfoCard(
            icon: Icons.calendar_today_outlined,
            title: "Fecha del pedido",
            value: formattedDate,
          ),
          const SizedBox(height: 12),

          if (order!.address != null) ...[
            _buildInfoCard(
              icon: Icons.location_on_outlined,
              title: "Dirección de entrega",
              value: order!.address!.address,
            ),
            const SizedBox(height: 12),
          ],

          _buildInfoCard(
            icon: statusInfo.icon,
            title: "Estado del pedido",
            value: order!.status.name,
            color: statusInfo.color,
            isStatus: true,
          ),

          const SizedBox(height: 20),
          _buildDivider(),
          const SizedBox(height: 16),

          _buildTotalSection(),
        ],
      ),
    );
  }

  /// Obtiene el color e icono según el estado del pedido
  StatusInfo _getStatusInfo(String status) {
    switch (status) {
      case 'pendiente':
        return StatusInfo(Colors.orangeAccent, Icons.schedule);
      case 'confirmada':
        return StatusInfo(Colors.blueAccent, Icons.verified);
      case 'enviada':
        return StatusInfo(Colors.purpleAccent, Icons.local_shipping);
      case 'entregada':
        return StatusInfo(Colors.green, Icons.check_circle);
      case 'cancelada':
        return StatusInfo(Colors.redAccent, Icons.cancel);
      default:
        return StatusInfo(Colors.grey, Icons.help_outline);
    }
  }

  /// Decoración del contenedor principal
  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white, Colors.grey[50]!],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 15,
          offset: const Offset(0, -5),
        ),
      ],
    );
  }

  /// Handle visual para indicar que se puede deslizar
  Widget _buildDragHandle() {
    return Container(
      width: 50,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  /// Divisor visual
  Widget _buildDivider() {
    return Divider(
      thickness: 1.5,
      color: Colors.grey[200],
    );
  }

  /// Sección del total con diseño destacado
  /// Sección del total con diseño compacto y elegante
Widget _buildTotalSection() {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          width: constraints.maxWidth * 0.52,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[300]!, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.payments_rounded,
                      color: Colors.green[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Total:",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Text(
                "\$${order!.total.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  color: Colors.green[800],
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}



  /// Widget para cada tarjeta de información
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    Color? color,
    bool isStatus = false,
  }) {
    final cardColor = color ?? Colors.grey[700]!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: isStatus ? cardColor.withOpacity(0.3) : Colors.grey[200]!,
          width: isStatus ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIconAvatar(icon, cardColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: isStatus ? cardColor : Colors.black87,
                    fontWeight: isStatus ? FontWeight.w700 : FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Avatar circular con icono
  Widget _buildIconAvatar(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 22,
      ),
    );
  }
}

/// Clase auxiliar para información de estado
class StatusInfo {
  final Color color;
  final IconData icon;

  StatusInfo(this.color, this.icon);
}