import 'package:flutter/material.dart';
import '../../../data/repositories/receta_repository.dart';
import '../../../data/models/receta_model.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/error_display.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import 'receta_detail_screen.dart';
import 'receta_form_screen.dart';

class RecetasScreen extends StatefulWidget {
  const RecetasScreen({super.key});

  @override
  State<RecetasScreen> createState() => _RecetasScreenState();
}

class _RecetasScreenState extends State<RecetasScreen> {
  final _repository = RecetaRepository();
  List<Receta> _recetas = [];
  List<Receta> _filteredRecetas = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategoria;

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
      final data = await _repository.getRecetas();
      setState(() {
        _recetas = data;
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
    var filtered = _recetas;

    if (_selectedCategoria != null) {
      filtered = filtered.where((r) => r.categoria == _selectedCategoria).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((r) =>
        r.nombre.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    setState(() => _filteredRecetas = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas'),
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
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar receta...',
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
                      FilterChip(
                        label: const Text('Todas'),
                        selected: _selectedCategoria == null,
                        onSelected: (_) {
                          setState(() => _selectedCategoria = null);
                          _applyFilters();
                        },
                      ),
                      ...AppConstants.categoriasReceta.map((categoria) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: FilterChip(
                            label: Text(categoria),
                            selected: _selectedCategoria == categoria,
                            onSelected: (_) {
                              setState(() => _selectedCategoria = categoria);
                              _applyFilters();
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const LoadingIndicator(message: 'Cargando recetas...')
                : _error != null
                    ? ErrorDisplay(message: _error!, onRetry: _loadData)
                    : _filteredRecetas.isEmpty
                        ? const Center(child: Text('No hay recetas'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: _filteredRecetas.length,
                            itemBuilder: (context, index) {
                              final receta = _filteredRecetas[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppTheme.getCategoryColor(receta.categoria),
                                    child: const Icon(Icons.menu_book, color: Colors.white),
                                  ),
                                  title: Text(receta.nombre),
                                  subtitle: Text(receta.categoria),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RecetaDetailScreen(receta: receta),
                                      ),
                                    );
                                  },
                                ),
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
            MaterialPageRoute(builder: (_) => const RecetaFormScreen()),
          );
          _loadData();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva Receta'),
      ),
    );
  }
}
