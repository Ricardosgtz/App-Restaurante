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

class ClientOrderDetailPage extends StatefulWidget {
  const ClientOrderDetailPage({super.key});

  @override
  State<ClientOrderDetailPage> createState() => _ClientOrderDetailPageState();
}

class _ClientOrderDetailPageState extends State<ClientOrderDetailPage> {
  late OrdersUseCases _ordersUseCases;
  Order? order;
  bool loading = true;
  bool isPanelVisible = true;

  @override
  void initState() {
    super.initState();
    _ordersUseCases = GetIt.instance<OrdersUseCases>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Order;
      _loadOrderDetail(args.id);
    });
  }

  Future<void> _loadOrderDetail(int orderId) async {
    setState(() => loading = true);
    final response = await _ordersUseCases.getOrderDetail.run(orderId);

    if (response is Success<Order>) {
      setState(() {
        order = response.data;
        loading = false;
      });
    } else if (response is Error) {
      Fluttertoast.showToast(
        msg: response.message,
        backgroundColor: Colors.redAccent,
      );
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: SpinKitThreeBounce(
            color: Colors.orange,
            size: 30,
            duration: Duration(seconds: 1),
          ),
        ),
      );
    }

    if (order == null) {
      return const Scaffold(
        body: Center(child: Text("No se encontró la orden.")),
      );
    }

    final formattedDate = DateFormat(
      'd MMM yyyy, h:mm a',
      'es_MX',
    ).format(order!.createdAt);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: HomeAppBar(title: 'Detalles del Pedido'),
      body: Stack(
        children: [
          // ✅ CONTENIDO PRINCIPAL
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧾 Número del pedido
                Row(
                  children: [
                    const Icon(
                      Icons.receipt_long_rounded,
                      size: 22,
                      color: Colors.deepOrange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pedido #${order!.id}',
                      style: GoogleFonts.poppins(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // 🕒 Fecha
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Realizado el $formattedDate',
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // 🍽 Restaurante
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.storefront_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order!.restaurant.name,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade900,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 📦 Título "Productos"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1.2,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      'Productos',
                      style: GoogleFonts.poppins(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: 0.2,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1.2,
                        indent: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 🛒 Lista de productos
                Expanded(
                  child:
                      order!.orderdetails.isNotEmpty
                          ? ListView.builder(
                            itemCount: order!.orderdetails.length,
                            itemBuilder: (context, index) {
                              final detail = order!.orderdetails[index];
                              return ClientOrderDetailItem(detail: detail);
                            },
                          )
                          : Center(
                            child: Text(
                              'No hay productos en este pedido',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ),

          // 🧩 Bottom panel deslizable
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            bottom: isPanelVisible ? 0 : -360,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 6) {
                  setState(() => isPanelVisible = false);
                } else if (details.delta.dy < -6) {
                  setState(() => isPanelVisible = true);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  child: ClientOrderDetailBottom(order!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
