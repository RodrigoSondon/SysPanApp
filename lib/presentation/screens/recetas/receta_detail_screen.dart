import 'package:flutter/material.dart';
import '../../../data/models/receta_model.dart';
import '../../../data/repositories/receta_repository.dart';
import '../../../core/widgets/loading_indicator.dart';

class RecetaDetailScreen extends StatefulWidget {
  final Receta receta;

  const RecetaDetailScreen({super.key, required this.receta});

  @override
  State<RecetaDetailScreen> createState() => _RecetaDetailScreenState();
}

class _RecetaDetailScreenState extends State<RecetaDetailScreen> {
  final _repository = RecetaRepository();
  List<IngredienteReceta>? _ingredientes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIngredientes();
  }

  Future<void> _loadIngredientes() async {
    try {
      final ingredientes = await _repository.getIngredientesReceta(widget.receta.idreceta!);
      setState(() {
        _ingredientes = ingredientes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receta.nombre),
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información General',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          label: 'Nombre',
                          value: widget.receta.nombre,
                        ),
                        _InfoRow(
                          label: 'Categoría',
                          value: widget.receta.categoria,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                if (_ingredientes != null && _ingredientes!.isNotEmpty) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ingredientes',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          ..._ingredientes!.map((ing) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.circle, size: 8),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${ing.nombreMateriaPrima ?? "Ingrediente"}: ${ing.cantidadnecesaria} ${ing.unidadmedida ?? ""}',
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                if (widget.receta.pasos != null && widget.receta.pasos!.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pasos de Preparación',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          Text(widget.receta.pasos!),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
