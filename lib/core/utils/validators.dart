class Validators {
  // Email Validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    
    return null;
  }
  
  // Password Validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    
    return null;
  }
  
  // Required Field Validator
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    return null;
  }
  
  // Number Validator
  static String? number(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    
    if (double.tryParse(value) == null) {
      return 'Ingrese un número válido';
    }
    
    return null;
  }
  
  // Positive Number Validator
  static String? positiveNumber(String? value, [String? fieldName]) {
    final numberError = number(value, fieldName);
    if (numberError != null) return numberError;
    
    if (double.parse(value!) <= 0) {
      return 'El valor debe ser mayor a 0';
    }
    
    return null;
  }
  
  // Phone Validator
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es requerido';
    }
    
    final phoneRegex = RegExp(r'^\d{10}$');
    
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''))) {
      return 'Ingrese un teléfono válido (10 dígitos)';
    }
    
    return null;
  }
  
  // Date Validator
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'La fecha es requerida';
    }
    
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Ingrese una fecha válida';
    }
  }
  
  // Future Date Validator
  static String? futureDate(String? value) {
    final dateError = date(value);
    if (dateError != null) return dateError;
    
    final selectedDate = DateTime.parse(value!);
    final now = DateTime.now();
    
    if (selectedDate.isBefore(DateTime(now.year, now.month, now.day))) {
      return 'La fecha debe ser futura';
    }
    
    return null;
  }
}
