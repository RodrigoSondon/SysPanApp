import 'package:flutter/material.dart';
import '../../../data/models/usuario_model.dart';
import '../../../data/repositories/usuario_repository.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_constants.dart';

class UsuarioFormScreen extends StatefulWidget {
  final Usuario? usuario;

  const UsuarioFormScreen({super.key, this.usuario});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = UsuarioRepository();
  final _authService = AuthService();
  
  late TextEditingController _nombreController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  
  String _rol = AppConstants.rolVendedor;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final user = widget.usuario;
    
    _nombreController = TextEditingController(text: user?.nombre ?? '');
    _emailController = TextEditingController(text: user?.correo ?? '');
    _passwordController = TextEditingController();
    _rol = user?.rol ?? AppConstants.rolVendedor;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.usuario == null) {
        // Creating new user - use auth service register
        await _authService.register(
          _nombreController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
          _rol,
        );
      } else {
        // Updating existing user - use repository
        final updatedUsuario = Usuario(
          idusuario: widget.usuario!.idusuario,
          nombre: _nombreController.text.trim(),
          correo: _emailController.text.trim(),
          password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
          rol: _rol,
        );
        
        await _repository.updateUsuario(updatedUsuario);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.usuario == null
                  ? 'Usuario creado exitosamente'
                  : 'Usuario actualizado exitosamente',
            ),
          ),
        );
        Navigator.pop(context, true);
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
          widget.usuario == null
              ? 'Nuevo Usuario'
              : 'Editar Usuario',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Nombre
            CustomTextField(
              controller: _nombreController,
              label: 'Nombre Completo',
              prefixIcon: Icons.person,
              validator: (value) => Validators.required(value, 'El nombre'),
            ),
            const SizedBox(height: 16),
            
            // Email
            CustomTextField(
              controller: _emailController,
              label: 'Correo Electrónico',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            
            // Password
            CustomTextField(
              controller: _passwordController,
              label: widget.usuario == null 
                  ? 'Contraseña' 
                  : 'Nueva Contraseña (dejar vacío para no cambiar)',
              prefixIcon: Icons.lock,
              obscureText: _obscurePassword,
              validator: widget.usuario == null
                  ? Validators.password
                  : null, // Password optional for edit
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            const SizedBox(height: 16),
            
            // Rol
            DropdownButtonFormField<String>(
              initialValue: _rol,
              decoration: const InputDecoration(
                labelText: 'Rol',
                prefixIcon: Icon(Icons.admin_panel_settings),
              ),
              items: [
                DropdownMenuItem(
                  value: AppConstants.rolAdministrador,
                  child: Row(
                    children: [
                      Icon(Icons.admin_panel_settings, size: 20, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text('Administrador'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: AppConstants.rolPanadero,
                  child: Row(
                    children: [
                      Icon(Icons.bakery_dining, size: 20, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Text('Panadero'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: AppConstants.rolVendedor,
                  child: Row(
                    children: [
                      Icon(Icons.point_of_sale, size: 20, color: Colors.green),
                      const SizedBox(width: 8),
                      const Text('Vendedor'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: AppConstants.rolCliente,
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text('Cliente'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _rol = value);
                }
              },
            ),
            const SizedBox(height: 32),
            
            // Submit Button
            CustomButton(
              text: widget.usuario == null ? 'Crear Usuario' : 'Actualizar',
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
