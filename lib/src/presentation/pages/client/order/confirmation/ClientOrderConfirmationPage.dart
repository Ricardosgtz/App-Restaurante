import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeAppBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ClientOrderConfirmationPage extends StatelessWidget {
  const ClientOrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context)!.settings.arguments as Order;
    final formattedDate =
        DateFormat('d MMMM yyyy', 'es_MX').format(order.createdAt);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: HomeAppBar(title: 'Confirmación de Orden'),

      // ✅ Botón fijo al fondo
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'client/home',
                  (route) => false,
                );
              },
              icon: const Icon(Icons.home_rounded),
              label: const Text("Volver al inicio"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),
          ),
        ),
      ),

      // ✅ Contenido desplazable
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // 🎉 Encabezado visual
            Icon(Icons.check_circle_rounded,
                size: 70, color: AppTheme.primaryColor),
            const SizedBox(height: 14),
            Text(
              "¡Orden realizada con éxito!",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              "Tu pedido ha sido confirmado correctamente",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // 🧾 Información principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoRow("Número de Orden:", "#${order.id}",
                      icon: Icons.receipt_long_rounded),
                  //_buildInfoRow("Cliente:",
                  //    "${order.client.name} ${order.client.lastname}",
                  //    icon: Icons.person),
                  _buildInfoRow("Fecha:", formattedDate,
                      icon: Icons.calendar_today_outlined),
                  //_buildInfoRow("Tipo de Pedido:", order.order.type,
                  //    icon: Icons.delivery_dining),
                  //_buildInfoRow("Restaurante:", order.restaurant.name,
                  //    icon: Icons.storefront_rounded),
                  _buildInfoRow("Estatus:", order.status.name,
                      icon: Icons.flag_circle_rounded),
                  if (order.address != null)
                    _buildInfoRow("Dirección:", order.address!.address,
                        icon: Icons.location_on_outlined),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 🛍️ Lista de productos
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Productos del pedido",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.orderdetails.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey[300]),
                itemBuilder: (context, index) {
                  final detail = order.orderdetails[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/img/no-image.png',
                        image: detail.product.image1 ?? '',
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (_, __, ___) => Image.asset(
                          'assets/img/no-image.png',
                          width: 45,
                          height: 45,
                        ),
                      ),
                    ),
                    title: Text(
                      detail.product.name,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      "x${detail.quantity}  •  \$${detail.unitPrice}",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Text(
                      "\$${detail.subtotal.toStringAsFixed(2)}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        fontSize: 14.5,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // 💰 Total
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total a pagar:",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "\$${order.total.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // espacio para evitar que se tape por el botón fijo
          ],
        ),
      ),
    );
  }

  /// 🔹 Fila estilizada con ícono
  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(icon, color: Colors.grey[600], size: 18),
          if (icon != null) const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 14.5,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: "$label ",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
