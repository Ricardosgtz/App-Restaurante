import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Página de confirmación con diseño tipo magazine/card stack
class ClientOrderConfirmationPage extends StatelessWidget {
  const ClientOrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context)!.settings.arguments as Order;
    final formattedDate = DateFormat(
      'd MMMM yyyy',
      'es_MX',
    ).format(order.createdAt);
    final formattedTime = DateFormat('h:mm a', 'es_MX').format(order.createdAt);

    // Calcular hora de entrega/llegada
    final deliveryTime = _calculateDeliveryTime(order);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Pedido Confirmado',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildSuccessHero(order),
            const SizedBox(height: 30),
            _buildStackedCards(
              order,
              formattedDate,
              formattedTime,
              deliveryTime,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: _buildBottomSheet(context),
    );
  }

  /// Calcular hora de entrega según el tipo de orden
  String _calculateDeliveryTime(Order order) {
    if (order.order.type == 'domicilio') {
      // Para domicilio: hora actual + 30 minutos
      final estimatedTime = order.createdAt.add(const Duration(minutes: 30));
      return DateFormat('h:mm a', 'es_MX').format(estimatedTime);
    } else if (order.arrivalTime != null && order.arrivalTime!.isNotEmpty) {
      try {
        final timeParts = order.arrivalTime!.split(':');
        if (timeParts.length >= 2) {
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final tempDateTime = DateTime(2000, 1, 1, hour, minute);
          return DateFormat('h:mm a', 'es_MX').format(tempDateTime);
        }
        return order.arrivalTime!;
      } catch (e) {
        return order.arrivalTime!;
      }
    } else {
      return '';
    }
  }

  /// Hero section con diseño asimétrico
  Widget _buildSuccessHero(Order order) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card principal con ángulo
          Transform.rotate(
            angle: -0.02,
            child: Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
            ),
          ),

          // Contenido centrado
          Container(
            width: double.infinity,
            height: 220,
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono check animado
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 70,
                ),
                const SizedBox(height: 16),
                Text(
                  'Pedido #${order.id}',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Confirmado exitosamente',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Cards apiladas con efecto 3D
  Widget _buildStackedCards(
    Order order,
    String date,
    String time,
    String deliveryTime,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Card de información
          _buildInfoCard(order, date, time, deliveryTime),
          const SizedBox(height: 16),
          // Card de productos
          _buildProductsCard(order),
          const SizedBox(height: 16),
          // Card de total
          _buildTotalCard(order),
        ],
      ),
    );
  }

  /// Card de información con diseño asimétrico
  Widget _buildInfoCard(
    Order order,
    String date,
    String time,
    String deliveryTime,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Información del Pedido',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Grid de información
          _buildInfoGrid(
            icon: Icons.calendar_today,
            label: 'Fecha',
            value: date,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildInfoGrid(
            icon: Icons.schedule,
            label: 'Hora',
            value: time,
            color: Colors.purple,
          ),

          // Mostrar hora de entrega/llegada según el tipo
          if (deliveryTime.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoGrid(
              icon:
                  order.order.type == 'domicilio'
                      ? Icons.local_shipping
                      : Icons.access_alarms,
              label:
                  order.order.type == 'domicilio'
                      ? 'Hora Aproximada de entrega'
                      : 'Hora de llegada',
              value: deliveryTime,
              color: Colors.deepOrange,
            ),
          ],

          const SizedBox(height: 16),
          _buildInfoGrid(
            icon: Icons.label,
            label: 'Estado',
            value: order.status.name,
            color: _getStatusColor(order.status.name),
          ),
          if (order.address != null) ...[
            const SizedBox(height: 16),
            _buildInfoGrid(
              icon: Icons.location_on,
              label: 'Dirección',
              value: order.address!.address,
              color: Colors.red,
              isMultiline: true,
            ),
          ],
        ],
      ),
    );
  }

  /// Grid item de información
  Widget _buildInfoGrid({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[500],
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: isMultiline ? 3 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Card de productos con diseño magazine
  Widget _buildProductsCard(Order order) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header con badge
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryColor.withOpacity(0.6),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Productos',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${order.orderdetails.length} items',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de productos
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            itemCount: order.orderdetails.length,
            separatorBuilder:
                (_, __) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: Colors.grey[200], height: 1),
                ),
            itemBuilder: (context, index) {
              return _buildProductItem(order.orderdetails[index]);
            },
          ),
        ],
      ),
    );
  }

  /// Item de producto con diseño horizontal
  Widget _buildProductItem(OrderDetail detail) {
    return Row(
      children: [
        // Imagen con efecto hover
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/img/no-image.png',
              image: detail.product.image1 ?? '',
              fit: BoxFit.cover,
              imageErrorBuilder:
                  (_, __, ___) => Container(
                    color: Colors.grey[100],
                    child: Icon(
                      Icons.restaurant,
                      color: Colors.grey[400],
                      size: 28,
                    ),
                  ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detail.product.name,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'x${detail.quantity} • \$${detail.unitPrice}',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Precio
        Text(
          '\$${detail.subtotal.toStringAsFixed(2)}',
          style: GoogleFonts.outfit(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  /// Card de total con diseño destacado
  Widget _buildTotalCard(Order order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[600]!, Colors.orange[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.7),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  order.total.toStringAsFixed(2),
                  style: GoogleFonts.outfit(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bottom sheet con botón moderno tipo "Glass + Gradient Glow"
  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, -8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              'client/home',
              (route) => false,
            );
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: AnimatedOpacity(
                    duration: const Duration(seconds: 2),
                    opacity: 0.1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.4),
                            Colors.transparent,
                          ],
                          radius: 1.2,
                          center: const Alignment(0.0, -0.6),
                        ),
                      ),
                    ),
                  ),
                ),

                // Contenido principal
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.home_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Volver al inicio",
                      style: GoogleFonts.outfit(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Obtiene color del estado
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'confirmada':
        return Colors.blue;
      case 'enviada':
        return Colors.purple;
      case 'entregada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
