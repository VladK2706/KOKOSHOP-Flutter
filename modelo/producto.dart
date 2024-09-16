class Producto {
  int? id_producto;
  String produc_nom;
  double produc_precio;
  String tipo_producto;

  Producto({
    this.id_producto,
    required this.produc_nom,
    required this.produc_precio,
    required this.tipo_producto,
  });

  factory Producto.fromMap(Map<String, dynamic> json) => Producto(
    id_producto: json['Id_producto'],
    produc_nom: json['produc_nom'],
    produc_precio: json['produc_precio'],
    tipo_producto: json['tipo_producto'],
  );

  Map<String, dynamic> toMap() => {
    'Id_producto': id_producto,
    'produc_nom': produc_nom,
    'produc_precio': produc_precio,
    'tipo_producto': tipo_producto,
  };
}