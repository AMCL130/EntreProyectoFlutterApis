class Producto {
  String id;
  String nombre;
  dynamic precio;
  dynamic cantidad;
  String descripcion;
  String estado;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.cantidad,
    required this.descripcion,
    required this.estado,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json["_id"],
      nombre: json["nombre"],
      precio: json["precio"],
      cantidad: json["cantidad"],
      descripcion: json["descripcion"],
      estado: json["estado"],
    );
  }
}
