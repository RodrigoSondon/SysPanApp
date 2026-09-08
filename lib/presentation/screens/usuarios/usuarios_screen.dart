import 'package:flutter/material.dart';
import '../../../data/repositories/usuario_repository.dart';
import '../../../data/models/usuario_model.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/error_display.dart';
import 'usuario_form_screen.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final _repository = UsuarioRepository();
  List<Usuario> _usuarios = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUsuarios();
  }

  Future<void> _loadUsuarios() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Dummy data
    final dummyData = [
      Usuario(idusuario: 1, nombre: 'Admin Dueño', correo: 'admin@syspan.com', rol: 'Administrador'),
      Usuario(idusuario: 2, nombre: 'Juan Panadero', correo: 'juan@syspan.com', rol: 'Panadero'),
      Usuario(idusuario: 3, nombre: 'María Vendedor 1', correo: 'maria@syspan.com', rol: 'Vendedor'),
      Usuario(idusuario: 4, nombre: 'Pedro Vendedor 2', correo: 'pedro@syspan.com', rol: 'Vendedor'),
      Usuario(idusuario: 5, nombre: 'Luis Repartidor', correo: 'luis@syspan.com', rol: 'Cliente'), // Or another role
    ];

    if (mounted) {
      setState(() {
        _usuarios = dummyData;
        _isLoading = false;
      });
    }
  }

  List<Usuario> get _filteredUsuarios {
    if (_searchQuery.isEmpty) {
      return _usuarios;
    }
    
    return _usuarios.where((usuario) {
      final nombre = usuario.nombre.toLowerCase();
      final correo = usuario.correo.toLowerCase();
      final rol = usuario.rol.toLowerCase();
      final query = _searchQuery.toLowerCase();
      
      return nombre.contains(query) || 
             correo.contains(query) || 
             rol.contains(query);
    }).toList();
  }

  Future<void> _handleEdit(Usuario usuario) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UsuarioFormScreen(usuario: usuario),
      ),
    );

    if (result == true) {
      _loadUsuarios();
    }
  }

  Future<void> _handleDelete(Usuario usuario) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Usuario'),
        content: Text('¿Está seguro que desea eliminar a ${usuario.nombre}?'),
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

    if (confirm == true && mounted) {
      // Dummy delete
      setState(() {
        _usuarios.removeWhere((u) => u.idusuario == usuario.idusuario);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario eliminado')),
      );
    }
  }

  Color _getRoleColor(String rol) {
    switch (rol) {
      case 'Administrador':
        return Colors.red;
      case 'Panadero':
        return Colors.orange;
      case 'Vendedor':
        return Colors.green;
      case 'Cliente':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String rol) {
    switch (rol) {
      case 'Administrador':
        return Icons.admin_panel_settings;
      case 'Panadero':
        return Icons.bakery_dining;
      case 'Vendedor':
        return Icons.point_of_sale;
      case 'Cliente':
        return Icons.person;
      default:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, email o rol...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const UsuarioFormScreen(),
            ),
          );
          
          if (result == true) {
            _loadUsuarios();
          }
        },
        tooltip: 'Nuevo Usuario',
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Cargando usuarios...')
          : _error != null
              ? ErrorDisplay(
                  message: _error!,
                  onRetry: _loadUsuarios,
                )
              : _filteredUsuarios.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'No hay usuarios registrados'
                                : 'No se encontraron usuarios',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredUsuarios.length,
                      itemBuilder: (context, index) {
                        final usuario = _filteredUsuarios[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: _getRoleColor(usuario.rol),
                              child: Icon(
                                _getRoleIcon(usuario.rol),
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              usuario.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.email, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        usuario.correo,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Chip(
                                  label: Text(
                                    usuario.rol,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  backgroundColor: _getRoleColor(usuario.rol).withOpacity(0.1),
                                  labelStyle: TextStyle(
                                    color: _getRoleColor(usuario.rol),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 20),
                                      SizedBox(width: 8),
                                      Text('Editar'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, size: 20, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Eliminar', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _handleEdit(usuario);
                                } else if (value == 'delete') {
                                  _handleDelete(usuario);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
