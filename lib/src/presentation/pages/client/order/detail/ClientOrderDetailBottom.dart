import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ClientOrderDetailBottom extends StatelessWidget {
  final Order? order;

  const ClientOrderDetailBottom(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    if (order == null) return const SizedBox();

    final formattedDate =
        DateFormat('d MMM yyyy, h:mm a', 'es_MX').format(order!.createdAt);

    Color statusColor;
    IconData statusIcon;

    switch (order!.status.name.toLowerCase()) {
      case 'pendiente':
        statusColor = Colors.orangeAccent;
        statusIcon = Icons.schedule;
        break;
      case 'confirmada':
        statusColor = Colors.blueAccent;
        statusIcon = Icons.verified;
        break;
      case 'enviada':
        statusColor = Colors.purpleAccent;
        statusIcon = Icons.local_shipping;
        break;
      case 'entregada':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'cancelada':
        statusColor = Colors.redAccent;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[100]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Encabezado visual
          Container(
            width: 50,
            height: 4,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // 🧾 Información en tarjetas pequeñas
          _buildInfoCard(
            icon: Icons.calendar_today_outlined,
            title: "Fecha del pedido",
            value: formattedDate,
          ),
          const SizedBox(height: 10),

          if (order!.address != null)
            _buildInfoCard(
              icon: Icons.location_on_outlined,
              title: "Dirección de entrega",
              value: order!.address!.address,
            ),
          const SizedBox(height: 10),

          _buildInfoCard(
            icon: statusIcon,
            title: "Estado del pedido",
            value: order!.status.name,
            color: statusColor,
            isStatus: true,
          ),

          const SizedBox(height: 18),
          const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 8),

          // 💰 Total visual
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Text(
                  "\$${order!.total.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: Colors.green[700],
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔧 Widget auxiliar para cada fila de información
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    Color? color,
    bool isStatus = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor:
                (color ?? Colors.grey).withOpacity(0.15),
            child: Icon(icon, color: color ?? Colors.grey[700], size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isStatus
                        ? (color ?? Colors.black)
                        : Colors.black87,
                    fontWeight:
                        isStatus ? FontWeight.w700 : FontWeight.w500,
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
}
