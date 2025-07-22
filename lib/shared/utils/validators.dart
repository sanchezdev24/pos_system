class Validators {
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El precio es requerido';
    }
    
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Ingrese un precio válido mayor a 0';
    }
    
    return null;
  }

  static String? validateStock(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El stock es requerido';
    }
    
    final stock = int.tryParse(value);
    if (stock == null || stock < 0) {
      return 'Ingrese un stock válido (0 o mayor)';
    }
    
    return null;
  }

  static String? validateBarcode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Barcode es opcional
    }
    
    if (value.length < 8 || value.length > 14) {
      return 'El código de barras debe tener entre 8 y 14 dígitos';
    }
    
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'El código de barras solo debe contener números';
    }
    
    return null;
  }
}