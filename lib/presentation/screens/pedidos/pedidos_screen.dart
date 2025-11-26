import 'package:flutter/material.dart';
import '../../../data/repositories/pedido_repository.dart';
import '../../../data/models/pedido_model.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/error_display.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/constants/app_constants.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  final _repository = PedidoRepository();
  List<Pedido> _pedidos = [];
  List<Pedido> _filteredPedidos = [];
  bool _isLoading = true;
  String? _error;
  String? _selectedEstado;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _repository.getPedidos();
      setState(() {
        _pedidos = data;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    var filtered = _pedidos;

    if (_selectedEstado != null) {
      filtered = filtered.where((p) => p.estado == _selectedEstado).toList();
    }

    setState(() => _filteredPedidos = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Todos'),
                    selected: _selectedEstado == null,
                    onSelected: (_) {
                      setState(() => _selectedEstado = null);
                      _applyFilters();
                    },
                  ),
                  ...AppConstants.estadosPedido.map((estado) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: FilterChip(
                        label: Text(estado),
                        selected: _selectedEstado == estado,
                        onSelected: (_) {
                          setState(() => _selectedEstado = estado);
                          _applyFilters();
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const LoadingIndicator(message: 'Cargando pedidos...')
                : _error != null
                    ? ErrorDisplay(message: _error!, onRetry: _loadData)
                    : _filteredPedidos.isEmpty
                        ? const Center(child: Text('No hay pedidos'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: _filteredPedidos.length,
                            itemBuilder: (context, index) {
                              final pedido = _filteredPedidos[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppTheme.getStatusColor(pedido.estado),
                                    child: Icon(
                                      pedido.prioridad == 'Urgente'
                                          ? Icons.priority_high
                                          : Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text('Pedido #${pedido.idpedido}'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (pedido.nombreCliente != null)
                                        Text('Cliente: ${pedido.nombreCliente}'),
                                      Text('Entrega: ${DateFormatter.formatDate(pedido.fechaentrega)}'),
                                      Row(
                                        children: [
                                          Chip(
                                            label: Text(pedido.estado),
                                            padding: EdgeInsets.zero,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          if (pedido.prioridad == 'Urgente') ...[
                                            const SizedBox(width: 8),
                                            const Chip(
                                              label: Text('Urgente'),
                                              backgroundColor: Colors.red,
                                              padding: EdgeInsets.zero,
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                  isThreeLine: true,
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to pedido form
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Pedido'),
      ),
    );
  }
}
