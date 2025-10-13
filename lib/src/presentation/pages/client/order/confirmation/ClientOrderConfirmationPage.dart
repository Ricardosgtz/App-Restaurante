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
    // ✅ Recibimos la orden completa desde Navigator.pushNamed
    final Order order = ModalRoute.of(context)!.settings.arguments as Order;

    // 📅 Formatear la fecha
    final formattedDate =
        DateFormat('d MMMM yyyy', 'es_MX').format(order.createdAt);

    return Scaffold(
      appBar: HomeAppBar(title: 'Confirmación de Orden'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Encabezado
              Center(
                child: Text(
                  "¡Orden exitosamente!",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // 🧾 Información básica de la orden
              _buildInfoRow("Número de Orden:", "#${order.id}"),
              _buildInfoRow(
                  "Cliente:", "${order.client.name} ${order.client.lastname}"),
              _buildInfoRow("Fecha de creación:", formattedDate),
              _buildInfoRow("Tipo de Pedido:", order.order.type),
              _buildInfoRow("Restaurante:", order.restaurant.name),
              _buildInfoRow("Estatus:", order.status.name),
              if (order.address != null)
                _buildInfoRow("Dirección:", order.address!.address),
              const Divider(height: 30),

              // 🛍️ Lista de productos
              Text(
                "Productos:",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.orderdetails.length,
                itemBuilder: (context, index) {
                  final detail = order.orderdetails[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      detail.product.name,
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                    subtitle: Text(
                      "Cantidad: ${detail.quantity}  •  Precio: \$${detail.unitPrice}",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    trailing: Text(
                      "\$${detail.subtotal.toStringAsFixed(2)}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  );
                },
              ),
              const Divider(height: 30),

              // 💰 Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total:",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "\$${order.total.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // ✅ Botón final
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      'client/home', // tu ruta principal del cliente
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.home),
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
                      borderRadius: BorderRadius.circular(10),
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

  /// 🔹 Helper para mostrar pares de texto (Etiqueta : Valor)
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
