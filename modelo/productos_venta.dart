class ProductoVenta {
  int id_venta;
  int id_producto;
  int cantidad;

  ProductoVenta({
    required this.id_venta,
    required this.id_producto,
    required this.cantidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_venta': id_venta,
      'id_producto': id_producto,
      'cantidad': cantidad,
    };
  }

  factory ProductoVenta.fromMap(Map<String, dynamic> map) {
    return ProductoVenta(
      id_venta: map['id_venta'] as int? ?? 0,
      id_producto: map['id_producto'] as int? ?? 0,
      cantidad: map['cantidad'] as int? ?? 0,
    );
  }
}
