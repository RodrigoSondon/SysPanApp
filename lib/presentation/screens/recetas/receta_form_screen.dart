import 'package:flutter/material.dart';
import '../../../data/models/receta_model.dart';
import '../../../data/models/materia_prima_model.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/dummy_db.dart';

class RecetaFormScreen extends StatefulWidget {
  final Receta? receta;

  const RecetaFormScreen({super.key, this.receta});

  @override
  State<RecetaFormScreen> createState() => _RecetaFormScreenState();
}

class _RecetaFormScreenState extends State<RecetaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nombreController;
  late TextEditingController _pasosController;
  
  String _categoria = AppConstants.categoriaPanDulce;
  bool _isLoading = false;
  List<IngredienteReceta> _ingredientes = [];

  @override
  void initState() {
    super.initState();
    final receta = widget.receta;
    
    _nombreController = TextEditingController(text: receta?.nombre ?? '');
    _pasosController = TextEditingController(text: receta?.pasos ?? '');
    _categoria = receta?.categoria ?? AppConstants.categoriaPanDulce;
    _ingredientes = List.from(receta?.ingredientes ?? []);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _pasosController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate save

    final receta = Receta(
      idreceta: widget.receta?.idreceta ?? DateTime.now().millisecondsSinceEpoch,
      nombre: _nombreController.text.trim(),
      categoria: _categoria,
      pasos: _pasosController.text.trim().isEmpty 
          ? null 
          : _pasosController.text.trim(),
      ingredientes: _ingredientes,
    );

    if (widget.receta == null) {
      DummyDb.instance.recetas.add(receta);
    } else {
      final index = DummyDb.instance.recetas.indexWhere((r) => r.idreceta == widget.receta!.idreceta);
      if (index != -1) {
        DummyDb.instance.recetas[index] = receta;
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.receta == null ? 'Receta creada' : 'Receta actualizada',
          ),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  void _mostrarDialogoIngrediente() {
    MateriaPrima? seleccionada;
    final cantidadCtrl = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Agregar Ingrediente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<MateriaPrima>(
                decoration: const InputDecoration(labelText: 'Materia Prima'),
                items: DummyDb.instance.materiasPrimas.map((mp) {
                  return DropdownMenuItem(value: mp, child: Text('${mp.nombre} (${mp.unidadmedida})'));
                }).toList(),
                onChanged: (val) => seleccionada = val,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cantidadCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad Necesaria',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (seleccionada != null && cantidadCtrl.text.isNotEmpty) {
                  final cant = double.tryParse(cantidadCtrl.text) ?? 1.0;
                  setState(() {
                    _ingredientes.add(IngredienteReceta(
                      idreceta: widget.receta?.idreceta ?? 0,
                      idmateriaprima: seleccionada!.idmateriaprima ?? 0,
                      cantidadnecesaria: cant,
                      nombreMateriaPrima: seleccionada!.nombre,
                      unidadmedida: seleccionada!.unidadmedida,
                    ));
                  });
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receta == null ? 'Nueva Receta' : 'Editar Receta'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            CustomTextField(
              controller: _nombreController,
              label: 'Nombre de la Receta',
              prefixIcon: Icons.menu_book,
              validator: (value) => Validators.required(value, 'El nombre'),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              initialValue: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                prefixIcon: Icon(Icons.category),
              ),
              items: AppConstants.categoriasReceta.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _categoria = value);
              },
            ),
            const SizedBox(height: 16),
            
            CustomTextField(
              controller: _pasosController,
              label: 'Pasos de Preparación (Opcional)',
              prefixIcon: Icons.list_alt,
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            
            // Sección de Ingredientes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ingredientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _mostrarDialogoIngrediente,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                )
              ],
            ),
            const Divider(),
            if (_ingredientes.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No hay ingredientes agregados', style: TextStyle(color: Colors.grey)),
              ),
            ..._ingredientes.map((ing) {
              return ListTile(
                title: Text(ing.nombreMateriaPrima ?? 'Desconocido'),
                subtitle: Text('${ing.cantidadnecesaria} ${ing.unidadmedida ?? ''}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _ingredientes.remove(ing);
                    });
                  },
                ),
              );
            }),
            
            const SizedBox(height: 32),
            
            CustomButton(
              text: widget.receta == null ? 'Crear Receta' : 'Actualizar Receta',
              onPressed: _handleSubmit,
              isLoading: _isLoading,
              icon: Icons.save,
            ),
          ],
        ),
      ),
    );
  }
}
