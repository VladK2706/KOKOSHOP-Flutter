class Producto {
  int? id_producto;
  String nombre;
  int cantidad;
  double precio;
  String tipo_producto;

  Producto({
    this.id_producto,
    required this.nombre,
    required this.cantidad,
    required this.precio,
    required this.tipo_producto,
  });

  factory Producto.fromMap(Map<String, dynamic> json) => Producto(
    id_producto: json['id_producto'],
    nombre: json['nombre'],
    cantidad: json['cantidad'],
    precio: json['precio'],
    tipo_producto: json['tipo_producto'],
  );

  Map<String, dynamic> toMap() => {
    'id_producto': id_producto,
    'nombre': nombre,
    'cantidad': cantidad,
    'precio': precio,
    'tipo_producto': tipo_producto,
  };
}