import 'package:flutter/material.dart';
import '../../../data/repositories/inventario_repository.dart';
import '../../../data/models/materia_prima_model.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_formatter.dart';

class MateriaPrimaFormScreen extends StatefulWidget {
  final MateriaPrima? materiaPrima;

  const MateriaPrimaFormScreen({super.key, this.materiaPrima});

  @override
  State<MateriaPrimaFormScreen> createState() => _MateriaPrimaFormScreenState();
}

class _MateriaPrimaFormScreenState extends State<MateriaPrimaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = InventarioRepository();
  
  late TextEditingController _nombreController;
  late TextEditingController _cantidadController;
  late TextEditingController _cantidadMinimaController;
  late TextEditingController _proveedorController;
  
  String _unidadMedida = 'kg';
  DateTime? _fechaCaducidad;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final mp = widget.materiaPrima;
    
    _nombreController = TextEditingController(text: mp?.nombre ?? '');
    _cantidadController = TextEditingController(
      text: mp?.cantidaddisponible.toString() ?? '',
    );
    _cantidadMinimaController = TextEditingController(
      text: mp?.cantidadminima.toString() ?? '',
    );
    _proveedorController = TextEditingController(text: mp?.proveedor ?? '');
    _unidadMedida = mp?.unidadmedida ?? 'kg';
    _fechaCaducidad = mp?.fechacaducidad;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadController.dispose();
    _cantidadMinimaController.dispose();
    _proveedorController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _fechaCaducidad ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    
    if (date != null) {
      setState(() => _fechaCaducidad = date);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final materiaPrima = MateriaPrima(
        idmateriaprima: widget.materiaPrima?.idmateriaprima,
        nombre: _nombreController.text.trim(),
        unidadmedida: _unidadMedida,
        cantidaddisponible: double.parse(_cantidadController.text),
        cantidadminima: double.parse(_cantidadMinimaController.text),
        proveedor: _proveedorController.text.trim().isEmpty 
            ? null 
            : _proveedorController.text.trim(),
        fechacaducidad: _fechaCaducidad,
      );

      if (widget.materiaPrima == null) {
        await _repository.createMateriaPrima(materiaPrima);
      } else {
        await _repository.updateMateriaPrima(materiaPrima);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.materiaPrima == null
                  ? 'Materia prima creada'
                  : 'Materia prima actualizada',
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
        title: Text(
          widget.materiaPrima == null
              ? 'Nueva Materia Prima'
              : 'Editar Materia Prima',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            CustomTextField(
              controller: _nombreController,
              label: 'Nombre',
              prefixIcon: Icons.inventory_2,
              validator: (value) => Validators.required(value, 'El nombre'),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              initialValue: _unidadMedida,
              decoration: const InputDecoration(
                labelText: 'Unidad de Medida',
                prefixIcon: Icon(Icons.straighten),
              ),
              items: AppConstants.unidadesMedida.map((unidad) {
                return DropdownMenuItem(
                  value: unidad,
                  child: Text(unidad),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _unidadMedida = value);
                }
              },
            ),
            const SizedBox(height: 16),
            
            CustomTextField(
              controller: _cantidadController,
              label: 'Cantidad Disponible',
              prefixIcon: Icons.numbers,
              keyboardType: TextInputType.number,
              validator: (value) => Validators.positiveNumber(value, 'La cantidad'),
            ),
            const SizedBox(height: 16),
            
            CustomTextField(
              controller: _cantidadMinimaController,
              label: 'Cantidad Mínima',
              prefixIcon: Icons.warning_amber,
              keyboardType: TextInputType.number,
              validator: (value) => Validators.positiveNumber(value, 'La cantidad mínima'),
            ),
            const SizedBox(height: 16),
            
            CustomTextField(
              controller: _proveedorController,
              label: 'Proveedor (Opcional)',
              prefixIcon: Icons.business,
            ),
            const SizedBox(height: 16),
            
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Fecha de Caducidad'),
              subtitle: Text(
                _fechaCaducidad != null
                    ? DateFormatter.formatDate(_fechaCaducidad!)
                    : 'No especificada',
              ),
              trailing: _fechaCaducidad != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() => _fechaCaducidad = null);
                      },
                    )
                  : null,
              onTap: _selectDate,
            ),
            const SizedBox(height: 32),
            
            CustomButton(
              text: widget.materiaPrima == null ? 'Crear' : 'Actualizar',
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
