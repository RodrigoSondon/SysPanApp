import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: AppConstants.tiposReporte.map((tipo) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(_getIconForReporte(tipo)),
              ),
              title: Text('Reporte de $tipo'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to specific report
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Generando reporte de $tipo...')),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getIconForReporte(String tipo) {
    switch (tipo) {
      case 'Ventas':
        return Icons.attach_money;
      case 'Costos':
        return Icons.receipt_long;
      case 'Mermas':
        return Icons.delete_outline;
      case 'Inventario':
        return Icons.inventory_2;
      case 'Ganancia':
        return Icons.trending_up;
      default:
        return Icons.analytics;
    }
  }
}
