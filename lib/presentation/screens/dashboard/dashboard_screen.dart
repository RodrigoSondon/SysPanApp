import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/usuario_model.dart';
import '../../../core/constants/app_constants.dart';
import '../auth/login_screen.dart';
import '../inventario/inventario_screen.dart';
import '../recetas/recetas_screen.dart';
import '../produccion/produccion_screen.dart';
import '../pedidos/pedidos_screen.dart';
import '../reportes/reportes_screen.dart';
import '../usuarios/usuarios_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();
  Usuario? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getCurrentUser();
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Está seguro que desea cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _authService.logout();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  List<_DashboardItem> _getDashboardItems() {
    final items = <_DashboardItem>[];
    final userRole = _currentUser?.rol ?? '';

    // Inventario - Todos los roles
    items.add(_DashboardItem(
      title: 'Inventario',
      subtitle: 'Materias primas',
      icon: Icons.inventory_2,
      color: Colors.blue,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InventarioScreen()),
      ),
    ));

    // Recetas - Todos los roles
    items.add(_DashboardItem(
      title: 'Recetas',
      subtitle: 'Recetario digital',
      icon: Icons.menu_book,
      color: Colors.orange,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RecetasScreen()),
      ),
    ));

    // Producción - Admin y Panadero
    if (userRole == AppConstants.rolAdministrador || 
        userRole == AppConstants.rolPanadero) {
      items.add(_DashboardItem(
        title: 'Producción',
        subtitle: 'Control diario',
        icon: Icons.factory,
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProduccionScreen()),
        ),
      ));
    }

    // Pedidos - Todos excepto Cliente
    if (userRole != AppConstants.rolCliente) {
      items.add(_DashboardItem(
        title: 'Pedidos',
        subtitle: 'Gestión de pedidos',
        icon: Icons.shopping_cart,
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PedidosScreen()),
        ),
      ));
    }

    // Reportes - Admin y Vendedor
    if (userRole == AppConstants.rolAdministrador || 
        userRole == AppConstants.rolVendedor) {
      items.add(_DashboardItem(
        title: 'Reportes',
        subtitle: 'Análisis y estadísticas',
        icon: Icons.analytics,
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReportesScreen()),
        ),
      ));
    }

    // Usuarios - Solo Admin
    if (userRole == AppConstants.rolAdministrador) {
      items.add(_DashboardItem(
        title: 'Usuarios',
        subtitle: 'Gestión de usuarios',
        icon: Icons.people,
        color: Colors.red,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UsuariosScreen()),
        ),
      ));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final dashboardItems = _getDashboardItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SysPan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        (_currentUser?.nombre.isNotEmpty == true) 
                            ? _currentUser!.nombre.substring(0, 1).toUpperCase() 
                            : 'U',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenido,',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            _currentUser?.nombre ?? 'Usuario',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black87, width: 1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _currentUser?.rol ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Dashboard Grid
            Text(
              'Módulos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: dashboardItems.length,
              itemBuilder: (context, index) {
                final item = dashboardItems[index];
                return _DashboardCard(item: item);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _DashboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _DashboardCard extends StatelessWidget {
  final _DashboardItem item;

  const _DashboardCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 48,
                color: item.color,
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
