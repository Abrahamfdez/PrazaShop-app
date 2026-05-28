/// Enumeración de categorías disponibles para productos
enum CategoriaProducto {
  froitas('Froitas'),
  verduras('Verduras'),
  peixe('Peixe'),
  carneMeats('Carne/Meats'),
  lacteos('Lácteos'),
  panaderia('Panadería'),
  conservas('Conservas'),
  bebidas('Bebidas'),
  otro('Outro');

  final String displayName;

  const CategoriaProducto(this.displayName);

  /// Obtiene una categoría por su nombre de display
  static CategoriaProducto fromDisplayName(String name) {
    try {
      return CategoriaProducto.values.firstWhere(
        (e) => e.displayName.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return CategoriaProducto.otro;
    }
  }

  /// Retorna la lista de categorías reales sin "Todos"
  static List<String> getAllDisplayNames() {
    return CategoriaProducto.values.map((e) => e.displayName).toList();
  }

  /// Retorna la lista de categorías con "Todos" al inicio
  static List<String> getCategoriesWithTodos() {
    return ['Todos'] + CategoriaProducto.values.map((e) => e.displayName).toList();
  }
}
