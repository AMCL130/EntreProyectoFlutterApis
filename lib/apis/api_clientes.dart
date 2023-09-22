import 'dart:convert';
// import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:apis_proyecto/screen_views/login.dart';
import 'package:http/http.dart' as http;
import 'package:apis_proyecto/componentes/input.dart';
// import 'package:apis_proyecto/screen_views/screen/clientes_screen.dart';

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

  void _deleteCliente(String clienteId) async {
    try {
      String url = "https://apisflutter.onrender.com/api/cliente/$clienteId";
      http.Response res = await http.delete(Uri.parse(url));
      if (res.statusCode == 200) {
        // El registro se eliminó correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente eliminado correctamente')),
        );
      } else {
        // Se produjo un error al eliminar el registro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el cliente')),
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

Future<Cliente> createCliente(Map<String, dynamic> cliente) async {
  try {
    final response = await http.post(
      Uri.parse('https://apisflutter.onrender.com/api/cliente'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'tipo': cliente['tipo'],
        'doc': cliente['doc'],
        'nombre': cliente['nombre'],
        'celular': cliente['celular'],
        'direccion': cliente['direccion'],
        'correo': cliente['correo'],
        'estado': cliente['estado'],
        'contrasena': cliente['contrasena']
      }),
    );

    if (response.statusCode == 201) {
      final nuevoCliente = Cliente.fromJson(jsonDecode(response.body));
      return nuevoCliente;
    } else {
      throw Exception(response.body);
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

class CrearClienteApi extends StatefulWidget {
  CrearClienteApi({Key? key}) : super(key: key);

  @override
  State<CrearClienteApi> createState() => _CrearClienteApiState();
}

class _CrearClienteApiState extends State<CrearClienteApi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _docController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  final volver = Clientes;

  Future<Cliente>? _futureCliente;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: (_futureCliente == null) ? _form() : _futureBuilder(),
    );
  }

  FutureBuilder<Cliente> _futureBuilder() {
    return FutureBuilder<Cliente>(
      future: _futureCliente,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Cliente creado correctamente',
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _futureCliente = null;
                  });
                },
                child: const Text('Crear otro Cliente'),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputComponent(
                label: 'tipo',
                controller: _tipoController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el tipo';
                  }
                  return null;
                },
              ),
              // const SizedBox(
              //   height: 5,
              // ),
              InputComponent(
                label: 'Doc',
                controller: _docController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese Documento';
                  }
                  return null;
                },
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              InputComponent(
                label: 'Nombre',
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
              //   height: 10,
              // ),
              InputComponent(
                label: 'Celular',
                controller: _celularController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el celular';
                  }
                  return null;
                },
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              InputComponent(
                label: 'Direccion',
                controller: _direccionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese direccion';
                  }
                  return null;
                },
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              InputComponent(
                label: 'Correo',
                controller: _correoController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese correo';
                  }
                  return null;
                },
              ),
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
              InputComponent(
                label: 'contrasena',
                controller: _contrasenaController,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese contraseña';
                  }
                  return null;
                },
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _futureCliente = createCliente({
                        'tipo': _tipoController.text,
                        'doc': _docController.text,
                        'nombre': _nombreController.text,
                        'celular': _celularController.text,
                        'direccion': _direccionController.text,
                        'correo': _correoController.text,
                        'estado': _estadoController.text,
                        'contrasena': _contrasenaController.text,
                      });
                    });

                    const Text('cliente creado con exito');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const HomePagedos()),
                    // );
                  } else {
                    print('no se pudo agregar el cliente');
                  }
                },
                child: const Text('Crear Cliente'),
              ),
            ],
          ),
        ));
  }
}

const String baseUrl = 'https://apisflutter.onrender.com/api/cliente';
