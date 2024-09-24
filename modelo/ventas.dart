class Ventas {
  int? ID;
  String fechaVenta;
  String tipoVenta;
  String estado;


  Ventas({
    this.ID,
    required this.fechaVenta,
    required this.tipoVenta,
    required this.estado,

  });

  factory Ventas.fromMap(Map<String, dynamic> json) => Ventas(
    ID: json['ID'],
    fechaVenta: json['fechaVenta'],
    tipoVenta: json['tipoVenta'],
    estado: json['estado'],

  );

  Map<String, dynamic> toMap()=>{
    'ID': ID,
    'fechaVenta': fechaVenta,
    'tipoVenta': tipoVenta,
    'estado': estado,

  };

}
