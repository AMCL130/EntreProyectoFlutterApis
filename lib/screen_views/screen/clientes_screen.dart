import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apis_proyecto/Modelos/modelo_cliente.dart';

class HomePagedos extends StatefulWidget {
  const HomePagedos({Key? key}) : super(key: key);

  @override
  State<HomePagedos> createState() => _HomePagedosState();
}

class _HomePagedosState extends State<HomePagedos> {
  int _currentIndex = 0;
  bool _isLoading = true;
  List<Cliente> clientes = [];
  Cliente? _selectedCliente; // Usuario seleccionado para edición

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
                  initialValue: clientes.nombre,
                  decoration: const InputDecoration(labelText: 'nombre'),
                  onChanged: (value) {
                    clientes.nombre = value;
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
      "id": clientes.id,
      "tipo": clientes.tipo,
      "nombre": clientes.nombre,
      "direccion": clientes.direccion,
      "correo": clientes.correo,
      "estado": clientes.estado,
      "contrasena": clientes.contrasena,
    };

    try {
      String url =
          "https://apisflutter.onrender.com/api/cliente${clientes.nombre}";

      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Cambios guardados con éxito en la API.
        print('Cambios guardados con éxito.');
      } else {
        // Error al guardar los cambios.
        print('Error al guardar los cambios.');
      }
    } catch (e) {
      print('Error al guardar los cambios: $e');
    }

    setState(() {
      _selectedCliente = null;
    });

    Navigator.of(context).pop(); // Cierra el modal.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 196, 81, 231),
        title: const Center(
          child: Text('Listado de clientes'),
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
                            Text("Id: ${clientes[index].id}"),
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
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Abre el modal de edición cuando se toca el botón de edición.
                            setState(() {
                              _selectedCliente = cliente;
                            });
                            _showEditModal(cliente);
                          },
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
