import 'package:flutter/material.dart';

class ClientOrderDetailPage extends StatelessWidget {
  const ClientOrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Orden')),
      body: const Center(child: Text('Aquí va el detalle de la orden')),
    );
  }
}
