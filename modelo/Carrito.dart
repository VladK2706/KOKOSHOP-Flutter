class Carrito{
  int? ID;
  int id_carrito;
  int id_cli;

  Carrito({
    this.ID,
    required this.id_carrito,
    required this.id_cli,
});

factory Carrito.fromMap(Map<String, dynamic> json) => Carrito(
  ID: json['ID'],
  id_carrito: json['id_carrito'],
  id_cli:  json['id_cli']
);

  Map<String, dynamic> toMap()=>{
    'ID' : ID,
    'id_carrito' : id_carrito,
    'id_cli' : id_cli,
  };
}