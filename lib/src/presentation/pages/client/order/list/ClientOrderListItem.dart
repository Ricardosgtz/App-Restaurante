import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ClientOrderListItem extends StatelessWidget {
  final Order order;

  const ClientOrderListItem(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('d MMM yyyy, h:mm a', 'es_MX').format(order.createdAt);

    // 🎨 Colores e íconos según estado
    Color statusColor;
    IconData statusIcon;

    switch (order.status.name.toLowerCase()) {
      case 'pendiente':
        statusColor = Colors.orangeAccent;
        statusIcon = Icons.hourglass_bottom;
        break;
      case 'confirmada':
        statusColor = Colors.blueAccent;
        statusIcon = Icons.verified_rounded;
        break;
      case 'en proceso':
        statusColor = Colors.amber;
        statusIcon = Icons.coffee;
        break;
      case 'enviada':
        statusColor = Colors.deepPurpleAccent;
        statusIcon = Icons.local_shipping;
        break;
      case 'entregada':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'cancelada':
        statusColor = Colors.redAccent;
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, 'client/order/detail', arguments: order),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: statusColor.withOpacity(0.4), width: 1.6),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.15),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🧾 Pedido + Estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(statusIcon, color: statusColor, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Pedido #${order.id}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  // 💰 Precio
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          statusColor.withOpacity(0.15),
                          statusColor.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Text(
                      '\$${order.total.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 📅 Fecha
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    formattedDate,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // 🏪 Restaurante
              Row(
                children: [
                  const Icon(Icons.storefront, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      order.restaurant.name,
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 📍 Dirección
              if (order.address != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.address!.address,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          color: Colors.black54,
                          height: 1.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 14),

              // 🏷️ Estado
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: statusColor.withOpacity(0.4),
                      width: 1.1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 17, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        order.status.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                          color: statusColor,
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
