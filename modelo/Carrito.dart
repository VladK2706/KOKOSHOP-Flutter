class Carrito {
  int? id_carrito;  // Cambiado a opcional
  int id_cli;

  Carrito({
    this.id_carrito,  // Ya no es requerido
    required this.id_cli,
  });

  factory Carrito.fromMap(Map<String, dynamic> json) => Carrito(
      id_carrito: json['id_carrito'],
      id_cli: json['id_cli']
  );

  Map<String, dynamic> toMap() => {
    'id_carrito': id_carrito,
    'id_cli': id_cli,
  };
}
