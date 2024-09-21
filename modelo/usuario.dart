class Usuario {
  int? ID;
  String nombre;
  String apellido;
  String rol;
  String tipo_doc;
  int num_doc;
  String ciudad;
  String direccion;
  String telefono;
  String correo;
  String contrasena;

  Usuario({
      this.ID,
      required this.nombre,
      required this.apellido,
      required this.rol,
      required this.tipo_doc,
      required this.num_doc,
      required this.ciudad,
      required this.direccion,
      required this.telefono,
      required this.correo,
      required this.contrasena,
      });

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
    ID: json['ID'],
    nombre: json['nombre'],
    apellido: json['apellido'],
    rol: json['rol'],
    tipo_doc: json['tipo_doc'],
    num_doc: json['num_doc'],
    ciudad: json['ciudad'],
    direccion: json['direccion'],
    telefono: json['telefono'],
    correo: json['correo'],
    contrasena: json['contrasena'],
  );

  Map<String, dynamic> toMap()=>{
    'ID': ID,
    'nombre': nombre,
    'apellido': apellido,
    'rol': rol,
    'tipo_doc': tipo_doc,
    'num_doc': num_doc,
    'ciudad': ciudad,
    'direccion': direccion,
    'correo': correo,
    'telefono': telefono,
    'contrasena': contrasena,
  };
}
