class Ventas {
  int? ID;
  double precio;
  String fechaVenta;
  String tipoVenta;
  String estado;


  Ventas({
    this.ID,
    required this.precio,
    required this.fechaVenta,
    required this.tipoVenta,
    required this.estado,

  });

  factory Ventas.fromMap(Map<String, dynamic> json) => Ventas(
    ID: json['ID'],
    precio: json['precio'],
    fechaVenta: json['fechaVenta'],
    tipoVenta: json['tipoVenta'],
    estado: json['estado'],

  );

  Map<String, dynamic> toMap()=>{
    'ID': ID,
    'precio': precio,
    'fechaVenta': fechaVenta,
    'tipoVenta': tipoVenta,
    'estado': estado,

  };

}
