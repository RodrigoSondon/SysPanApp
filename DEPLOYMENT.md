# Guía de Deployment - SysPan App

Esta guía te ayudará a configurar y ejecutar la aplicación SysPan en un nuevo ambiente.

## Requisitos Previos

### Software Necesario

1. **Flutter SDK** (versión 3.9.2 o superior)
   - Descarga: https://flutter.dev/docs/get-started/install
   - Verifica la instalación: `flutter --version`

2. **Dart SDK** (incluido con Flutter)
   - Verifica: `dart --version`

3. **Android Studio** (para desarrollo Android)
   - Descarga: https://developer.android.com/studio
   - Incluye Android SDK y emuladores

4. **VS Code** (opcional pero recomendado)
   - Extensiones: Flutter, Dart

5. **Git**
   - Para clonar el repositorio

### Backend API

- **NodeJS API** corriendo en tu servidor
- **PostgreSQL** configurado con las tablas necesarias
- **Puerto por defecto**: 3000

## Pasos de Instalación

### 1. Clonar el Repositorio

```terminal
git clone <url-del-repositorio>
cd SysPanApp
```

### 2. Verificar Instalación de Flutter

```terminal
flutter doctor
```

### 3. Instalar Dependencias

```terminal
flutter pub get
```

Este comando descarga todas las dependencias especificadas en `pubspec.yaml`:
- `flutter_bloc`: State management
- `http`: HTTP requests
- `shared_preferences`: Local storage
- `intl`: Date formatting
- `fl_chart`: Charts
- `google_fonts`: Custom fonts
- `flutter_svg`: SVG support
- `provider`: Dependency injection

### 4. Configurar la URL del API

Edita el archivo `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  // IMPORTANTE: Cambia esta URL según tu ambiente
  
  // Para desarrollo local en emulador Android:
  static const String baseUrl = 'http://10.0.2.2:3000';
  
  // Para desarrollo local en dispositivo físico o iOS:
  // static const String baseUrl = 'http://TU_IP_LOCAL:3000';
  
  // Para producción:
  // static const String baseUrl = 'https://api.tupansys.com';
  
  // ... resto del código
}
```
### 5. Configurar Emulador o Dispositivo

#### Opción A: Emulador Android

```terminal
# Listar emuladores disponibles
flutter emulators

# Crear un nuevo emulador (si no tienes)
flutter emulators --create

# Iniciar emulador
flutter emulators --launch <emulator_id>
```

#### Opción B: Dispositivo Físico

1. Habilita **Modo Desarrollador** en tu dispositivo Android
2. Habilita **Depuración USB**
3. Conecta el dispositivo por USB
4. Verifica: `flutter devices`

#### Opción C: Web (Chrome/Edge)

```terminal
# Habilitar web
flutter config --enable-web

# Verificar
flutter devices
```

### 6. Ejecutar la Aplicación

```terminal
# Ver dispositivos disponibles
flutter devices

# Ejecutar en dispositivo específico
flutter run -d <device_id>

# Ejemplos:
flutter run -d emulator-5554    # Android emulator
flutter run -d edge             # Web browser
flutter run -d chrome           # Chrome browser
```

