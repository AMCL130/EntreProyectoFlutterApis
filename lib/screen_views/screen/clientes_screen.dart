import 'package:apis_proyecto/apis/api_clientes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:apis_proyecto/Modelos/modelo_cliente.dart';

class HomePagedos extends StatefulWidget {
  const HomePagedos({Key? key}) : super(key: key);

  @override
  State<HomePagedos> createState() => _HomePagedosState();
}

class _HomePagedosState extends State<HomePagedos> {
  int _currentIndex = 0;
  bool _isLoading = true;
  List<Cliente> clientes = [];
  Cliente? _selectedCliente;
  List<String> seleccioEstado = ['activo', 'inactivo'];
  bool _modalOpen = false;

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
        List<dynamic> jsonData = json.decode(res.body)["msg"];
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

  void _showEditModal(Cliente clientes) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Editar cliente'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: clientes.id,
                  decoration: const InputDecoration(labelText: 'Id'),
                  onChanged: (value) {
                    clientes.id = value;
                  },
                ),
                TextFormField(
                  initialValue: clientes.tipo,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  onChanged: (value) {
                    clientes.tipo = value;
                  },
                ),
                TextFormField(
                  initialValue: clientes.doc.toString(),
                  decoration: const InputDecoration(labelText: 'Documento'),
                  onChanged: (value) {
                    clientes.doc = int.parse(value);
                  },
                ),
                TextFormField(
                  initialValue: clientes.nombre,
                  decoration: const InputDecoration(labelText: 'nombre'),
                  onChanged: (value) {
                    clientes.nombre = value;
                  },
                ),
                TextFormField(
                  initialValue: clientes.celular.toString(),
                  decoration: const InputDecoration(labelText: 'Celular'),
                  onChanged: (value) {
                    clientes.celular = int.parse(value);
                  },
                ),
                TextFormField(
                  initialValue: clientes.direccion,
                  decoration: const InputDecoration(labelText: 'direccion'),
                  onChanged: (value) {
                    clientes.direccion = value;
                  },
                ),
                TextFormField(
                  initialValue: clientes.correo,
                  decoration: const InputDecoration(labelText: 'correo'),
                  onChanged: (value) {
                    clientes.correo = value;
                  },
                ),
                TextFormField(
                  initialValue: clientes.estado,
                  decoration: const InputDecoration(labelText: 'estado'),
                  onChanged: (value) {
                    clientes.estado = value;
                  },
                ),
                TextFormField(
                  initialValue: clientes.contrasena,
                  decoration: const InputDecoration(labelText: 'Contrasena'),
                  onChanged: (value) {
                    clientes.contrasena = value;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Aquí puedes guardar los cambios en la API y cerrar el modal.
                    _saveChangesAndCloseModal(clientes);
                  },
                  child: const Text('Guardar Cambios'),
                ),
              ],
            )));
      },
    );
  }

  //GUARDA LOS CAMBIOS EN LA API

  void _saveChangesAndCloseModal(Cliente clientes) async {
    // Construye el cuerpo de la solicitud con los datos actualizados.
    Map<String, dynamic> requestBody = {
      "_id": clientes.id,
      "tipo": clientes.tipo,
      "doc": clientes.doc,
      "nombre": clientes.nombre,
      "celular": clientes.celular,
      "direccion": clientes.direccion,
      "correo": clientes.correo,
      "estado": clientes.estado,
      "contrasena": clientes.contrasena,
    };

    try {
      String url = "https://apisflutter.onrender.com/api/cliente";

      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Cambios guardados con exito.');
        if (mounted && _modalOpen) {}
      } else {
        print('Error al guardar los cambios.');
      }
    } catch (e) {
      print('Error al guardar los cambios: $e');
    }

    setState(() {
      _selectedCliente = null;
    });

    Navigator.of(context).pop();
  }

  void _deleteCliente(cliente) async {
    try {
      String url = "https://apisflutter.onrender.com/api/cliente";
      http.Response res = await http.delete(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'_id': cliente}));
      if (res.statusCode == 200) {
        // El registro se eliminó correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente eliminado correctamente')),
        );
        _getData();
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
        backgroundColor: const Color.fromARGB(255, 196, 81, 231),
        title: Row(
          children: <Widget>[
            const Expanded(
              child: Center(
                child: Text('Listado de clientes'),
              ),
            ),
            
            IconButton(
              icon: Icon(Icons.auto_mode_sharp),
              onPressed: () {
                _getData();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: ListView.builder(
                    itemCount: clientes.length,
                    itemBuilder: (context, index) {
                      final cliente = clientes[index];
                      return ListTile(
                          title: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Id: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: clientes[index].id,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Tipo: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: clientes[index].tipo,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Documento: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: clientes[index].doc.toString(),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Nombre: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: clientes[index].nombre,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Celular: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: clientes[index].celular.toString(),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Dirección: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: clientes[index].direccion,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Correo: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: clientes[index].correo,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Estado: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: clientes[index].estado,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Contraseña: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: clientes[index].contrasena,
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Colors.purple,
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 1,
                              )
                            ],
                          ),
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.purple,
                              ),
                              onPressed: () {
                                // Abre el modal de edición cuando se toca el botón de edición.
                                setState(() {
                                  _selectedCliente = cliente;
                                });
                                _showEditModal(cliente);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.purple,
                              ),
                              onPressed: () {
                                // Abre el modal de edición cuando se toca el botón de edición.
                                _deleteCliente(cliente.id);
                              },
                            ),
                          ]));
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
