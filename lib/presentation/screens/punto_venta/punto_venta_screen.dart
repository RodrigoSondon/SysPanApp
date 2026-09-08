import 'package:flutter/material.dart';
import '../../../app/presentation/global/colors.dart';

class PuntoVentaScreen extends StatefulWidget {
  const PuntoVentaScreen({super.key});

  @override
  State<PuntoVentaScreen> createState() => _PuntoVentaScreenState();
}

class _PuntoVentaScreenState extends State<PuntoVentaScreen> {
  // Dummy data para productos
  final List<Map<String, dynamic>> _productos = [
    {'id': '1', 'nombre': 'Concha Vainilla', 'precio': 12.0, 'stock': 45, 'icono': Icons.bakery_dining},
    {'id': '2', 'nombre': 'Concha Chocolate', 'precio': 12.0, 'stock': 30, 'icono': Icons.bakery_dining},
    {'id': '3', 'nombre': 'Bolillo', 'precio': 3.5, 'stock': 120, 'icono': Icons.breakfast_dining},
    {'id': '4', 'nombre': 'Telera', 'precio': 4.0, 'stock': 85, 'icono': Icons.breakfast_dining},
    {'id': '5', 'nombre': 'Oreja', 'precio': 15.0, 'stock': 20, 'icono': Icons.cookie},
    {'id': '6', 'nombre': 'Cuernito', 'precio': 14.0, 'stock': 25, 'icono': Icons.breakfast_dining},
    {'id': '7', 'nombre': 'Dona Chocolate', 'precio': 16.0, 'stock': 15, 'icono': Icons.donut_large},
    {'id': '8', 'nombre': 'Dona Azúcar', 'precio': 15.0, 'stock': 18, 'icono': Icons.donut_small},
  ];

  // Carrito de compras
  final List<Map<String, dynamic>> _carrito = [];

  void _agregarAlCarrito(Map<String, dynamic> producto) {
    setState(() {
      final index = _carrito.indexWhere((p) => p['id'] == producto['id']);
      if (index != -1) {
        _carrito[index]['cantidad']++;
      } else {
        _carrito.add({
          'id': producto['id'],
          'nombre': producto['nombre'],
          'precio': producto['precio'],
          'cantidad': 1,
        });
      }
    });
  }

  void _removerDelCarrito(int index) {
    setState(() {
      if (_carrito[index]['cantidad'] > 1) {
        _carrito[index]['cantidad']--;
      } else {
        _carrito.removeAt(index);
      }
    });
  }

  void _procesarVenta() {
    if (_carrito.isEmpty) return;
    
    // Aquí se llamaría al servicio de ventas
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Venta Exitosa', style: TextStyle(color: AppColors.success)),
        content: const Text('La venta se ha registrado correctamente en el sistema y se ha descontado el inventario.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _carrito.clear();
              });
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  double get _subtotal {
    return _carrito.fold(0, (sum, item) => sum + (item['precio'] * item['cantidad']));
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punto de Venta'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.background,
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Catálogo de Productos (Izquierda)
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildCatalogoProductos(),
          ),
        ),
        
        // Separador
        const VerticalDivider(width: 1, thickness: 1),
        
        // Carrito de compras / Ticket (Derecha)
        Expanded(
          flex: 1,
          child: Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(16.0),
            child: _buildTicket(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildCatalogoProductos(),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12.0),
          child: _buildTicket(),
        ),
      ],
    );
  }

  Widget _buildCatalogoProductos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catálogo de Productos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 5 : MediaQuery.of(context).size.width > 800 ? 4 : 3,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _productos.length,
            itemBuilder: (context, index) {
              final prod = _productos[index];
              return InkWell(
                onTap: () => _agregarAlCarrito(prod),
                borderRadius: BorderRadius.circular(12),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(prod['icono'], size: 40, color: AppColors.primary),
                        const SizedBox(height: 12),
                        Text(
                          prod['nombre'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          '\$${prod['precio'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.secondary, 
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                        ),
                        Text(
                          'Stock: ${prod['stock']}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTicket() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ticket Actual',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (_carrito.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_sweep, color: AppColors.error),
                onPressed: () {
                  setState(() {
                    _carrito.clear();
                  });
                },
                tooltip: 'Vaciar ticket',
              ),
          ],
        ),
        const Divider(),
        Expanded(
          child: _carrito.isEmpty
              ? const Center(
                  child: Text(
                    'No hay productos en el ticket',
                    style: TextStyle(color: AppColors.textHint),
                  ),
                )
              : ListView.builder(
                  itemCount: _carrito.length,
                  itemBuilder: (context, index) {
                    final item = _carrito[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item['nombre'], style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text('\$${item['precio'].toStringAsFixed(2)} x ${item['cantidad']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${(item['precio'] * item['cantidad']).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                            onPressed: () => _removerDelCarrito(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subtotal:', style: TextStyle(fontSize: 16)),
            Text('\$${_subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'TOTAL:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
            ),
            Text(
              '\$${_subtotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _carrito.isEmpty ? null : _procesarVenta,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            'COBRAR TICKET',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
