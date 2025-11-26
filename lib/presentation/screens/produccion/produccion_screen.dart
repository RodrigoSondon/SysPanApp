import 'package:flutter/material.dart';

class ProduccionScreen extends StatelessWidget {
  const ProduccionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Producción'),
      ),
      body: const Center(
        child: Text('Módulo de Producción - En desarrollo'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to production form
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar Producción'),
      ),
    );
  }
}
