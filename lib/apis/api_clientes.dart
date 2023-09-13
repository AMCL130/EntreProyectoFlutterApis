import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:apis_proyecto/screen_views/login.dart';
import 'package:http/http.dart' as http;

class Clientes extends StatefulWidget {
  const Clientes({Key? key}) : super(key: key);

  @override
  State<Clientes> createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  int _currentIndex = 0; // Agrega esta línea para inicializar _currentIndex
  bool _isLoading = true;
  List<Cliente> clientes = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    try {
      String url = "https://apisflutter.onrender.com/api/cliente";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        List<dynamic> jsonData = json.decode(res.body)["clientes"];
        clientes = jsonData.map((item) => Cliente.fromJson(item)).toList();
        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception("No day datos para cargar");
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
      ),
      body: Center(
        // Envuelve todo el contenido con Center
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xff6610f2),
                Color(0xffff1493),
              ],
              begin: Alignment.topCenter,
            ),
          ),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: ListView.builder(
                    itemCount: clientes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Column(
                          children: [
                            Text("Nombre: ${clientes[index].nombre}"),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Tipo: ${clientes[index].tipo}"),
                            Text("Documento: ${clientes[index].doc}"),
                            Text("Nombre: ${clientes[index].nombre}"),
                            Text("Celular: ${clientes[index].celular}"),
                            Text("Direccion: ${clientes[index].direccion}"),
                            Text("Estado: ${clientes[index].estado}"),
                            Text("Contraseña: ${clientes[index].contrasena}"),
                          ],
                        ),
                        // Puedes agregar más detalles aquí si es necesario
                      );
                    },
                  ),
                ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Clientes',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Productos',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 0) {
              // Navega a la página de inicio (HomePage)
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            }
          });
        },
      ),
    );
  }
}

class Cliente{
    String id;
    String tipo;
    int doc;
    String nombre;
    int celular;
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
      doc: json["doc"],
      nombre: json["nombre"],
      celular: json["celular"],
      direccion: json["direccion"],
      correo: json["correo"],
      estado: json["estado"],
      contrasena: json["contrasena"],
    );
  }
}
