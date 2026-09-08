import 'package:flutter/material.dart';
import '../../../data/repositories/inventario_repository.dart';
import '../../../data/models/materia_prima_model.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/error_display.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../app/presentation/global/colors.dart';
import 'materia_prima_form_screen.dart';

import '../../../data/dummy_db.dart';

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

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Dummy data
    final dummyData = DummyDb.instance.materiasPrimas;

    if (mounted) {
      setState(() {
        _materiasPrimas = dummyData;
        _applyFilters();
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
      // Dummy delete
      setState(() {
        _materiasPrimas.removeWhere((m) => m.idmateriaprima == materiaPrima.idmateriaprima);
        _applyFilters();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Materia prima eliminada')),
      );
    }
  }

  int get _lowStockCount => _materiasPrimas.where((m) => m.isBajoStock).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Low Stock Alert
                if (_lowStockCount > 0)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Stock Bajo: $_lowStockCount ${_lowStockCount == 1 ? 'producto necesita' : 'productos necesitan'} reabastecimiento',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Search Bar
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _applyFilters();
                  },
                ),
                const SizedBox(height: 12),
                
                // Filter Chips
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
      selectedColor: AppColors.secondary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
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
    final categoryColor = AppTheme.getMateriaPrimaColor(materiaPrima.nombre);
    final statusColor = materiaPrima.isBajoStock
        ? AppColors.error
        : materiaPrima.isExpiringSoon
            ? AppColors.warning
            : AppColors.success;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Category Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Name and Category
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        materiaPrima.nombre,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (materiaPrima.categoria != null)
                        Text(
                          materiaPrima.categoria!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Stock Info
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    label: 'Stock:',
                    value: '${materiaPrima.cantidaddisponible} ${materiaPrima.unidadmedida}',
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    label: 'Mínimo:',
                    value: '${materiaPrima.stockminimo} ${materiaPrima.unidadmedida}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    label: 'Costo:',
                    value: '\$${materiaPrima.costoporkilo?.toStringAsFixed(2) ?? '0.00'}',
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    label: 'Total:',
                    value: '\$${materiaPrima.totalCost.toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
            
            if (materiaPrima.fechacaducidad != null) ...[
              const SizedBox(height: 8),
              _InfoItem(
                label: 'Vence:',
                value: DateFormatter.formatDate(materiaPrima.fechacaducidad!),
                valueColor: materiaPrima.isExpired
                    ? AppColors.error
                    : materiaPrima.isExpiringSoon
                        ? AppColors.warning
                        : null,
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Editar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Eliminar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
