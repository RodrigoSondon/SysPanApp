import 'package:flutter/material.dart';
import '../../../data/repositories/receta_repository.dart';
import '../../../data/models/receta_model.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_constants.dart';

class RecetaFormScreen extends StatefulWidget {
  final Receta? receta;

  const RecetaFormScreen({super.key, this.receta});

  @override
  State<RecetaFormScreen> createState() => _RecetaFormScreenState();
}

class _RecetaFormScreenState extends State<RecetaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = RecetaRepository();
  
  late TextEditingController _nombreController;
  late TextEditingController _pasosController;
  
  String _categoria = AppConstants.categoriaPanDulce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final receta = widget.receta;
    
    _nombreController = TextEditingController(text: receta?.nombre ?? '');
    _pasosController = TextEditingController(text: receta?.pasos ?? '');
    _categoria = receta?.categoria ?? AppConstants.categoriaPanDulce;
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

    try {
      final receta = Receta(
        idreceta: widget.receta?.idreceta,
        nombre: _nombreController.text.trim(),
        categoria: _categoria,
        pasos: _pasosController.text.trim().isEmpty 
            ? null 
            : _pasosController.text.trim(),
      );

      if (widget.receta == null) {
        await _repository.createReceta(receta);
      } else {
        await _repository.updateReceta(receta);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.receta == null ? 'Receta creada' : 'Receta actualizada',
            ),
          ),
        );
        Navigator.pop(context);
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
              value: _categoria,
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
