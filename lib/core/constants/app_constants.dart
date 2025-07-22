

class AppConstants {
  static const String appName = 'Punto de Venta';
  static const double taxRate = 0.16; // 16% IVA
  static const String currency = '\$';
  static const String dateFormat = 'dd/MM/yyyy HH:mm';
  static const String dateOnlyFormat = 'dd/MM/yyyy';
  
  // Configuración de la aplicación
  static const int maxProductsPerPage = 50;
  static const int searchDelayMs = 500;
  static const double minPrice = 0.01;
  static const int maxStock = 99999;
  
  // Mensajes de error comunes
  static const String genericError = 'Ha ocurrido un error inesperado';
  static const String networkError = 'Error de conexión';
  static const String databaseError = 'Error en la base de datos';
  static const String validationError = 'Datos inválidos';
  
  // Configuración de base de datos
  static const String databaseName = 'pos_database.db';
  static const int databaseVersion = 1;
}