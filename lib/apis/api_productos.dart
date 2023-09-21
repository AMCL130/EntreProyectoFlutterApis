import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:apis_proyecto/screen_views/login.dart';
import 'package:http/http.dart' as http;
import 'package:apis_proyecto/componentes/input.dart';
import 'package:apis_proyecto/screen_views/screen/clientes_screen.dart';

class Productos extends StatefulWidget {
  const Productos({Key? key}) : super(key: key);

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  int _currentIndex = 0; // Agrega esta línea para inicializar _currentIndex
  bool _isLoading = true;
  List<Producto> productos = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    try {
      String url = "https://apisflutter.onrender.com/api/producto";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        List<dynamic> jsonData = json.decode(res.body)["productos"];
        productos = jsonData.map((item) => Producto.fromJson(item)).toList();
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

  void _deleteProducto(String productoId) async {
    try {
      String url = "https://apisflutter.onrender.com/api/producto/$productoId";
      http.Response res = await http.delete(Uri.parse(url));
      if (res.statusCode == 200) {
        // El registro se eliminó correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto eliminado correctamente')),
        );
      } else {
        // Se produjo un error al eliminar el registro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar')),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
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
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Column(
                          children: [
                            Text("Nombre: ${productos[index].nombre}"),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("nombre: ${productos[index].nombre}"),
                            Text("precio: ${productos[index].precio}"),
                            Text("cantidad: ${productos[index].cantidad}"),
                            Text(
                                "descripcion: ${productos[index].descripcion}"),
                            Text("Estado: ${productos[index].estado}"),
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
            label: 'Productos',
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

Future<Producto> createProducto(Map<String, dynamic> producto) async {
  try {
    final response = await http.post(
      Uri.parse('https://apisflutter.onrender.com/api/producto'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': producto['nombre'],
        'precio': producto['precio'],
        'cantidad': producto['cantidad'],
        'descripcion': producto['descripcion'],
        'estado': producto['estado'],
      }),
    );

    if (response.statusCode == 201) {
      final nuevoProducto = Producto.fromJson(jsonDecode(response.body));
      return nuevoProducto;
    } else {
      throw Exception(response.body);
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

class CrearProductoApi extends StatefulWidget {
  CrearProductoApi({Key? key}) : super(key: key);

  @override
  State<CrearProductoApi> createState() => _CrearProductoApiState();
}

class _CrearProductoApiState extends State<CrearProductoApi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  volver() {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePagedos()),
    );
  }

  Future<Producto>? _futureProducto;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: (_futureProducto == null) ? _form() : _futureBuilder(),
    );
  }

  FutureBuilder<Producto> _futureBuilder() {
    return FutureBuilder<Producto>(
      future: _futureProducto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Producto creado correctamente',
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _futureProducto = null;
                  });
                },
                child: const Text('Crear otro Producto'),
              ),
            ],
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }

  Form _form() {
    return Form(
      key: _formKey,
      // child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InputComponent(
            label: 'nombre',
            controller: _nombreController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese el nombre';
              }
              return null;
            },
          ),
          // const SizedBox(
          //   height: 5,
          // ),
          InputComponent(
            label: 'precio',
            controller: _precioController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese el precio';
              }
              return null;
            },
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          InputComponent(
            label: 'cantidad',
            controller: _cantidadController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese la cantidad';
              }
              return null;
            },
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          InputComponent(
            label: 'descripcion',
            controller: _descripcionController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese la descripcion';
              }
              return null;
            },
          ),
          // const SizedBox(
          //   height: 10,
          // ),

          // const SizedBox(
          //   height: 10,
          // ),

          InputComponent(
            label: 'Estado',
            controller: _estadoController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese estado';
              }
              return null;
            },
          ),
          // const SizedBox(
          //   height: 10,
          // ),

          // const SizedBox(
          //   height: 10,
          // ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _futureProducto = createProducto({
                    'nombre': _nombreController.text,
                    'precio': _precioController.text,
                    'cantidad': _cantidadController.text,
                    'descripcion': _descripcionController.text,
                    'estado': _estadoController.text,
                  });
                });
                
                const Text('Producto creado con exito');
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const HomePagedos()),
                // );
              } else {
                print('no se pudo agregar el cliente');
              }
            },
            child: const Text('Crear Producto'),
          ),
        ],
      ),
    );
  }
}

const String baseUrl = 'https://apisflutter.onrender.com/api/producto';
