
class Cliente {
  String id;
  String tipo;
  dynamic doc;
  String nombre;
  dynamic celular;
  String direccion;
  String correo;
  String estado;
  String contrasena;

  Cliente(
      {required this.id,
      required this.tipo,
      required this.doc,
      required this.nombre,
      required this.celular,
      required this.direccion,
      required this.correo,
      required this.estado,
      required this.contrasena});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json["_id"],
      tipo: json["tipo"],
      doc: int.parse(json["doc"]) ,
      nombre: json["nombre"],
      celular: json["celular"] ,
      direccion: json["direccion"],
      correo: json["correo"],
      estado: json["estado"],
      contrasena: json["contrasena"],
    );
  }
}