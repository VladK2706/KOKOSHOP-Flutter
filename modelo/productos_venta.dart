class ProductoVenta {
  int? idVenta;
  int idProducto;
  int cantidad;

  ProductoVenta({
    this.idVenta,
    required this.idProducto,
    required this.cantidad,
  });

  factory ProductoVenta.fromMap(Map<String, dynamic> json) => ProductoVenta(
    idVenta: json['idVenta'],
    idProducto: json['idProducto'],
    cantidad: json['cantidad'],
  );

  Map<String, dynamic> toMap() => {
    'idVenta': idVenta,
    'idProducto': idProducto,
    'cantidad': cantidad,
  };
}
