import 'package:flutter/material.dart';
import '../../../data/repositories/inventario_repository.dart';
import '../../../data/models/materia_prima_model.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/error_display.dart';
import '../../../core/utils/date_formatter.dart';
import 'materia_prima_form_screen.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final _repository = InventarioRepository();
  List<MateriaPrima> _materiasPrimas = [];
  List<MateriaPrima> _filteredMateriasPrimas = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String _filterType = 'Todos';

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
      final data = await _repository.getMateriasPrimas();
      setState(() {
        _materiasPrimas = data;
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
    var filtered = _materiasPrimas;

    // Apply filter type
    if (_filterType == 'Bajo Stock') {
      filtered = filtered.where((m) => m.isBajoStock).toList();
    } else if (_filterType == 'Por Vencer') {
      filtered = filtered.where((m) => m.isExpiringSoon).toList();
    } else if (_filterType == 'Vencidos') {
      filtered = filtered.where((m) => m.isExpired).toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((m) =>
        m.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (m.proveedor?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
      ).toList();
    }

    setState(() {
      _filteredMateriasPrimas = filtered;
    });
  }

  Future<void> _deleteMateriaPrima(MateriaPrima materiaPrima) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Materia Prima'),
        content: Text('¿Está seguro que desea eliminar "${materiaPrima.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _repository.deleteMateriaPrima(materiaPrima.idmateriaprima!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Materia prima eliminada')),
          );
          _loadData();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar materia prima...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _applyFilters();
                  },
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Todos',
                        isSelected: _filterType == 'Todos',
                        onSelected: () {
                          setState(() => _filterType = 'Todos');
                          _applyFilters();
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Bajo Stock',
                        isSelected: _filterType == 'Bajo Stock',
                        onSelected: () {
                          setState(() => _filterType = 'Bajo Stock');
                          _applyFilters();
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Por Vencer',
                        isSelected: _filterType == 'Por Vencer',
                        onSelected: () {
                          setState(() => _filterType = 'Por Vencer');
                          _applyFilters();
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Vencidos',
                        isSelected: _filterType == 'Vencidos',
                        onSelected: () {
                          setState(() => _filterType = 'Vencidos');
                          _applyFilters();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: _isLoading
                ? const LoadingIndicator(message: 'Cargando inventario...')
                : _error != null
                    ? ErrorDisplay(message: _error!, onRetry: _loadData)
                    : _filteredMateriasPrimas.isEmpty
                        ? const Center(
                            child: Text('No hay materias primas'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: _filteredMateriasPrimas.length,
                            itemBuilder: (context, index) {
                              final materiaPrima = _filteredMateriasPrimas[index];
                              return _MateriaPrimaCard(
                                materiaPrima: materiaPrima,
                                onEdit: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MateriaPrimaFormScreen(
                                        materiaPrima: materiaPrima,
                                      ),
                                    ),
                                  );
                                  _loadData();
                                },
                                onDelete: () => _deleteMateriaPrima(materiaPrima),
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MateriaPrimaFormScreen()),
          );
          _loadData();
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
    );
  }
}

class _MateriaPrimaCard extends StatelessWidget {
  final MateriaPrima materiaPrima;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MateriaPrimaCard({
    required this.materiaPrima,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: materiaPrima.isBajoStock
              ? Colors.red
              : materiaPrima.isExpiringSoon
                  ? Colors.orange
                  : Colors.green,
          child: const Icon(Icons.inventory_2, color: Colors.white),
        ),
        title: Text(materiaPrima.nombre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${materiaPrima.cantidaddisponible} ${materiaPrima.unidadmedida}'),
            if (materiaPrima.proveedor != null)
              Text('Proveedor: ${materiaPrima.proveedor}'),
            if (materiaPrima.fechacaducidad != null)
              Text(
                'Vence: ${DateFormatter.formatDate(materiaPrima.fechacaducidad!)}',
                style: TextStyle(
                  color: materiaPrima.isExpired
                      ? Colors.red
                      : materiaPrima.isExpiringSoon
                          ? Colors.orange
                          : null,
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Eliminar', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
        ),
        isThreeLine: true,
      ),
    );
  }
}
