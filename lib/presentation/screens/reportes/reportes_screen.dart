import 'package:flutter/material.dart';
import '../../../app/presentation/global/colors.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes Financieros'),
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen de la Semana',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Stats Row
            Row(
              children: [
                Expanded(child: _buildSummaryCard('Ventas Totales', '\$42,500', Icons.attach_money, AppColors.success)),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('Mermas', '\$1,200', Icons.delete_outline, AppColors.error)),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('Ganancia', '\$28,400', Icons.trending_up, const Color(0xFF00BCD4))),
              ],
            ),
            
            const SizedBox(height: 24),
            const Text(
              'Ventas por Día (Simulado)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Dummy Chart
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildChartBar('Lun', 0.5),
                  _buildChartBar('Mar', 0.6),
                  _buildChartBar('Mie', 0.4),
                  _buildChartBar('Jue', 0.7),
                  _buildChartBar('Vie', 0.85),
                  _buildChartBar('Sab', 1.0),
                  _buildChartBar('Dom', 0.9),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Top 5 Productos Más Vendidos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Column(
                children: [
                  _buildTopProductItem('1', 'Bolillo', '850 piezas', '\$2,975.00'),
                  const Divider(height: 1),
                  _buildTopProductItem('2', 'Concha Vainilla', '420 piezas', '\$5,040.00'),
                  const Divider(height: 1),
                  _buildTopProductItem('3', 'Concha Chocolate', '380 piezas', '\$4,560.00'),
                  const Divider(height: 1),
                  _buildTopProductItem('4', 'Telera', '300 piezas', '\$1,200.00'),
                  const Divider(height: 1),
                  _buildTopProductItem('5', 'Oreja', '150 piezas', '\$2,250.00'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildChartBar(String day, double percent) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 120 * percent,
          decoration: BoxDecoration(
            color: const Color(0xFF00BCD4),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildTopProductItem(String rank, String name, String qty, String total) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF00BCD4).withOpacity(0.2),
        child: Text(rank, style: const TextStyle(color: Color(0xFF00BCD4), fontWeight: FontWeight.bold)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(qty),
      trailing: Text(total, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
    );
  }
}
