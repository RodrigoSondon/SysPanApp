import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/usuario_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../app/presentation/global/colors.dart';
import '../auth/login_screen.dart';
import '../inventario/inventario_screen.dart';
import '../recetas/recetas_screen.dart';
import '../produccion/produccion_screen.dart';
import '../punto_venta/punto_venta_screen.dart';
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
      icon: Icons.inventory_2_outlined,
      color: AppColors.secondary,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InventarioScreen()),
      ),
    ));

    // Recetas - Todos los roles
    items.add(_DashboardItem(
      title: 'Recetas',
      subtitle: 'Recetario digital',
      icon: Icons.menu_book_outlined,
      color: AppColors.primary,
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
        icon: Icons.factory_outlined,
        color: AppColors.success,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProduccionScreen()),
        ),
      ));
    }

    // Punto de Venta - Todos excepto Cliente
    if (userRole != AppConstants.rolCliente) {
      items.add(_DashboardItem(
        title: 'Punto de Venta',
        subtitle: 'Caja y mostrador',
        icon: Icons.point_of_sale_outlined,
        color: const Color(0xFF9C27B0),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PuntoVentaScreen()),
        ),
      ));
    }

    // Reportes - Admin y Vendedor
    if (userRole == AppConstants.rolAdministrador || 
        userRole == AppConstants.rolVendedor) {
      items.add(_DashboardItem(
        title: 'Reportes',
        subtitle: 'Análisis y estadísticas',
        icon: Icons.analytics_outlined,
        color: const Color(0xFF00BCD4),
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
        icon: Icons.people_outline,
        color: AppColors.error,
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bakery_dining,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PanSys',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Administrador',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: _handleLogout,
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Welcome Section
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        (_currentUser?.nombre.isNotEmpty == true) 
                            ? _currentUser!.nombre.substring(0, 1).toUpperCase() 
                            : 'U',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentUser?.nombre ?? 'Usuario',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _currentUser?.email ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Panel General Title
                Text(
                  'Panel General',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Resumen del día',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                
                // Stats Cards - Responsive Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Use 4 columns on larger screens, 2 on smaller
                    final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: crossAxisCount == 4 ? 1.2 : 1.5,
                      children: [
                        _StatCard(
                          title: 'Ventas Hoy',
                          value: '\$8,450',
                          icon: Icons.attach_money,
                          color: AppColors.success,
                        ),
                        _StatCard(
                          title: 'Ganancias Netas',
                          value: '\$4,620',
                          icon: Icons.trending_up,
                          color: AppColors.secondary,
                        ),
                        _StatCard(
                          title: 'Productos Activos',
                          value: '24',
                          icon: Icons.shopping_bag_outlined,
                          color: AppColors.primary,
                        ),
                        _StatCard(
                          title: 'Usuarios',
                          value: '8',
                          icon: Icons.people_outline,
                          color: const Color(0xFF9C27B0),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                
                // Alert Banners
                _AlertBanner(
                  message: 'Levadura Seca - Stock bajo (<5kg)',
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.warning,
                ),
                const SizedBox(height: 12),
                _AlertBanner(
                  message: 'Recordatorio: Registrar ventas al cierre del turno',
                  icon: Icons.info_outline,
                  color: AppColors.info,
                ),
                const SizedBox(height: 24),
                
                // Modules Section
                Text(
                  'Módulos',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Modules Grid - Responsive
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Use more columns on larger screens
                    final crossAxisCount = constraints.maxWidth > 900 
                        ? 4 
                        : constraints.maxWidth > 600 
                            ? 3 
                            : 2;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: dashboardItems.length,
                      itemBuilder: (context, index) {
                        final item = dashboardItems[index];
                        return _DashboardCard(item: item);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;

  const _AlertBanner({
    required this.message,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final _DashboardItem item;

  const _DashboardCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
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
