class Venta {
  int? Id_venta;
  int Id_usuario;
  String fechaVenta;
  String tipoVenta;
  String estado;


  Venta({
    this.Id_venta,
    required this.Id_usuario,
    required this.fechaVenta,
    required this.tipoVenta,
    required this.estado,

  });

  factory Venta.fromMap(Map<String, dynamic> json) => Venta(
    Id_venta: json['Id_venta'],
    Id_usuario: json['Id_usuario'],
    fechaVenta: json['fechaVenta'],
    tipoVenta: json['tipoVenta'],
    estado: json['estado'],

  );

  Map<String, dynamic> toMap()=>{
    'Id_venta': Id_venta,
    'Id_usuario': Id_usuario,
    'fechaVenta': fechaVenta,
    'tipoVenta': tipoVenta,
    'estado': estado,

  };

}
