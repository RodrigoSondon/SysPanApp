# SysPan - Sistema de Gestión de Panadería

Aplicación móvil Flutter para la gestión integral de una panadería.

## 🚀 Características

- ✅ **Autenticación** con control de acceso basado en roles
- ✅ **Gestión de Inventario** con alertas de stock bajo y fechas de caducidad
- ✅ **Recetario Digital** con categorías e ingredientes
- ✅ **Control de Producción** diaria
- ✅ **Pedidos de Clientes** con prioridades y estados
- ✅ **Reportes** de costos, ganancias y mermas
- ✅ **Gestión de Usuarios** (solo administradores)

## 📋 Requisitos Previos

- Flutter SDK 3.9.2 o superior
- Dart SDK
- API de NodeJS corriendo (backend)
- Base de datos PostgreSQL configurada

## 🔧 Instalación

1. **Clonar el repositorio:**
   ```bash
   cd SysPanApp
   ```

2. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```

3. **Configurar la URL del API:**
   
   Editar `lib/core/constants/api_constants.dart`:
   ```dart
   static const String baseUrl = 'http://TU_API_URL/api';
   ```

4. **Ejecutar la aplicación:**
   ```bash
   flutter run
   ```

## 👥 Roles de Usuario

| Rol | Inventario | Recetas | Producción | Pedidos | Reportes | Usuarios |
|-----|-----------|---------|------------|---------|----------|----------|
| **Administrador** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Panadero** | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Vendedor** | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ |
| **Cliente** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

## 📱 Pantallas Principales

### Autenticación
- Login con email y contraseña
- Validación de formularios
- Manejo de sesión con JWT

### Dashboard
- Acceso rápido a módulos según rol
- Perfil de usuario
- Navegación intuitiva

### Inventario
- Lista de materias primas
- Búsqueda y filtros (Todos, Bajo Stock, Por Vencer, Vencidos)
- Agregar/Editar/Eliminar materias primas
- Alertas visuales de stock

### Recetas
- Catálogo de recetas por categoría
- Detalles con ingredientes y pasos
- Crear y editar recetas

### Pedidos
- Lista de pedidos con filtros por estado
- Indicadores de prioridad
- Gestión de estados (Pendiente, En Proceso, Entregado)

### Reportes
- Reportes de ventas, costos, mermas, inventario y ganancias

## 🏗️ Arquitectura

El proyecto sigue **Clean Architecture**:

```
lib/
├── core/           # Utilidades compartidas
├── data/           # Modelos, repositorios, servicios
└── presentation/   # Pantallas y widgets
```

## 🎨 Diseño

- **Material Design 3**
- **Tema personalizado** con colores cálidos de panadería
- **Fuente:** Poppins (Google Fonts)
- **Componentes reutilizables**

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter_bloc: ^8.1.3      # Gestión de estado
  http: ^1.1.0              # Peticiones HTTP
  shared_preferences: ^2.2.2 # Almacenamiento local
  intl: ^0.19.0             # Internacionalización
  fl_chart: ^0.66.0         # Gráficas
  google_fonts: ^6.1.0      # Fuentes
```

## 🔌 API Endpoints

La aplicación espera los siguientes endpoints en el backend:

```
POST   /api/auth/login
POST   /api/auth/logout
GET    /api/materias-primas
POST   /api/materias-primas
PUT    /api/materias-primas/:id
DELETE /api/materias-primas/:id
GET    /api/recetas
GET    /api/pedidos
GET    /api/reportes
...
```

Ver `lib/core/constants/api_constants.dart` para la lista completa.

## 🧪 Testing

```bash
# Análisis de código
flutter analyze

# Tests unitarios
flutter test
```

## 📄 Licencia

Este proyecto es privado y no está publicado en pub.dev.

## 👨‍💻 Desarrollo

Desarrollado con Flutter siguiendo las mejores prácticas:
- Clean Architecture
- Separación de responsabilidades
- Código reutilizable
- Manejo de errores
- Validación de formularios
- Estados de carga

---

**SysPan** - Sistema de Gestión de Panadería 🥖
