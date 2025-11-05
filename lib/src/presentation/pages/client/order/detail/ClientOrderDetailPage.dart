import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Order.dart';
import 'package:flutter_application_1/src/domain/useCases/oreder/OrdersUseCases.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/detail/ClientOrderDetailBottom.dart';
import 'package:flutter_application_1/src/presentation/pages/client/order/detail/ClientOrderDetailItem.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeAppBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Página de detalle del pedido del cliente
class ClientOrderDetailPage extends StatefulWidget {
  const ClientOrderDetailPage({super.key});

  @override
  State<ClientOrderDetailPage> createState() => _ClientOrderDetailPageState();
}

class _ClientOrderDetailPageState extends State<ClientOrderDetailPage>
    with SingleTickerProviderStateMixin {
  late OrdersUseCases _ordersUseCases;
  Order? order;
  bool loading = true;
  bool isPanelVisible = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _ordersUseCases = GetIt.instance<OrdersUseCases>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Order;
      _loadOrderDetail(args.id);
    });
  }

  void _initializeController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadOrderDetail(int orderId) async {
    setState(() => loading = true);

    final response = await _ordersUseCases.getOrderDetail.run(orderId, context);

    if (response is Success<Order>) {
      setState(() {
        order = response.data;
        loading = false;
      });
    } else if (response is Error) {
      _showErrorToast(response.message);
      setState(() => loading = false);
    }
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
  }

  void _togglePanel() {
    setState(() {
      isPanelVisible = !isPanelVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return _buildLoadingScreen();
    }

    if (order == null) {
      return _buildErrorScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppBar(title: 'Detalles del Pedido'),
      body: Stack(
        children: [
          _buildMainContent(),
          _buildBottomPanel(),

          Positioned(
            right: 20, // distancia desde el borde derecho
            bottom:
                28, // 👈 súbelo para no tapar el total (ajusta si lo necesitas)
            child: _buildTogglePanelButton(),
          ),
        ],
      ),
    );
  }

  /// Pantalla de carga
  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitThreeBounce(color: Colors.orange, size: 35),
            const SizedBox(height: 20),
            Text(
              'Cargando detalles...',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Pantalla de error
  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 80, color: Colors.red[300]),
            const SizedBox(height: 20),
            Text(
              "No se encontró la orden",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Por favor, intenta nuevamente",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Contenido principal de la página (solo los productos tienen scroll)
  Widget _buildMainContent() {
    final formattedDate = DateFormat(
      'd MMM yyyy, h:mm a',
      'es_MX',
    ).format(order!.createdAt);

    return Padding(
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: 10,
        bottom: MediaQuery.of(context).size.height * 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderHeader(formattedDate),
          const SizedBox(height: 28),
          _buildProductsSectionTitle(),
          const SizedBox(height: 12),

          // 🔹 Solo la lista de productos hace scroll
          Expanded(
            child:
                order!.orderdetails.isEmpty
                    ? _buildEmptyProductsMessage()
                    : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: order!.orderdetails.length,
                      itemBuilder: (context, index) {
                        final detail = order!.orderdetails[index];
                        return ClientOrderDetailItem(detail: detail);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  /// Encabezado con número de pedido, restaurante y fecha
  Widget _buildOrderHeader(String formattedDate) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[50]!, Colors.orange[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 24,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pedido ID
                Text(
                  'Pedido #${order!.id}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                // Restaurante
                Row(
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      size: 14,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order!.restaurant.name,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Fecha del pedido
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Título de la sección de productos
  Widget _buildProductsSectionTitle() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1.5,
            endIndent: 12,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange[100]!, Colors.orange[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_bag_rounded,
                size: 18,
                color: Colors.orange[800],
              ),
              const SizedBox(width: 8),
              Text(
                'Productos',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.orange[900],
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Divider(color: Colors.grey[300], thickness: 1.5, indent: 12),
        ),
      ],
    );
  }

  /// Mensaje cuando no hay productos
  Widget _buildEmptyProductsMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No hay productos en este pedido',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Panel inferior deslizable
  /// Panel inferior deslizable
  Widget _buildBottomPanel() {
    // ⚙️ Altura dinámica del panel según el tipo de pedido
    final double panelHeight =
        (order?.order.type == 'domicilio')
            ? 500
            : 400; // ajusta según tu diseño

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      bottom: isPanelVisible ? 0 : -panelHeight, // ✅ dinámico
      left: 0,
      right: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 8) {
            if (isPanelVisible) _togglePanel();
          } else if (details.delta.dy < -8) {
            if (!isPanelVisible) _togglePanel();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: ClientOrderDetailBottom(order),
          ),
        ),
      ),
    );
  }

  /// Botón flotante para mostrar/ocultar el panel
  Widget _buildTogglePanelButton() {
    return FloatingActionButton(
      onPressed: _togglePanel,
      backgroundColor: Colors.orange,
      child: AnimatedRotation(
        turns: isPanelVisible ? 0.5 : 0,
        duration: const Duration(milliseconds: 300),
        child: const Icon(
          Icons.expand_more_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
