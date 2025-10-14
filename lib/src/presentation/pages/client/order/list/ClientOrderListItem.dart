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
        statusIcon = Icons.schedule;
        break;
      case 'confirmada':
        statusColor = Colors.blueAccent;
        statusIcon = Icons.verified;
        break;
      case 'en proceso':
        statusColor = Colors.amber;
        statusIcon = Icons.sync;
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
      case 'rechazada':
        statusColor = Colors.grey;
        statusIcon = Icons.block;
        break;
      default:
        statusColor = Colors.blueGrey;
        statusIcon = Icons.help_outline;
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'client/order/detail', arguments: order);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              // 🎨 Franja lateral del color del estado
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                  ),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Encabezado: Pedido + Precio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.receipt_long,
                                color: Colors.orange,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green.shade400,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '\$${order.total.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // 🍽️ Restaurante
                    Row(
                      children: [
                        const Icon(Icons.storefront,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            order.restaurant.name,
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              color: Colors.black54,
                              //fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
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
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

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

                    const SizedBox(height: 12),

                    // 🏷️ Estado (chip visual)
                    Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: statusColor.withOpacity(0.3),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(statusIcon, color: statusColor, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              order.status.name,
                              style: GoogleFonts.poppins(
                                color: statusColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
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
