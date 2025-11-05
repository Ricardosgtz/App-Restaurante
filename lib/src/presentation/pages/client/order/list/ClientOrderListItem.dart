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
    final Map<String, Map<String, dynamic>> statusMap = {
      'pendiente': {
        'color': Colors.orangeAccent,
        'icon': Icons.hourglass_bottom_rounded
      },
      'confirmada': {
        'color': Colors.blueAccent,
        'icon': Icons.verified_rounded
      },
      'en proceso': {'color': Colors.amber, 'icon': Icons.coffee_rounded},
      'enviada': {'color': Colors.deepPurpleAccent, 'icon': Icons.local_shipping},
      'entregada': {'color': Colors.green, 'icon': Icons.check_circle_rounded},
      'cancelada': {'color': Colors.redAccent, 'icon': Icons.cancel_rounded},
    };

    final color =
        statusMap[order.status.name.toLowerCase()]?['color'] ?? Colors.grey;
    final icon =
        statusMap[order.status.name.toLowerCase()]?['icon'] ?? Icons.help_outline_rounded;

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, 'client/order/detail', arguments: order),
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
                      colors: [
                        color,
                        color.withOpacity(0.6),
                      ],
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
                              'Pedido #${order.id}',
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
                          '\$${order.total.toStringAsFixed(2)}',
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
                        const Icon(Icons.storefront_rounded,
                            size: 18, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.restaurant.name,
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
                    if (order.address != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 18, color: Colors.redAccent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              order.address!.address,
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
                        const Icon(Icons.calendar_today_rounded,
                            size: 16, color: Colors.blueAccent),
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

                    // 🏷️ Badge de estado
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
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
                            Icon(icon, size: 17, color: color),
                            const SizedBox(width: 6),
                            Text(
                              order.status.name,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.5,
                                color: color,
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
