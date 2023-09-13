import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apis_proyecto/Modelos/modelo_producto.dart';



class HomePageuno extends StatefulWidget {
  const HomePageuno({Key? key}) : super(key: key);

  @override
  State<HomePageuno> createState() => _HomePageunoState();
}

class _HomePageunoState extends State<HomePageuno> {
  int _currentIndex = 0;
  bool _isLoading = true;
  List<Producto> productos = [];
  Producto? _selectedProducto; // Usuario seleccionado para edición

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
        List<dynamic> jsonData = json.decode(res.body)["msg"];
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

  void _showEditModal(Producto productos) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Editar producto',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: productos.id,
                decoration: const InputDecoration(labelText: 'Id'),
                onChanged: (value) {
                  productos.id = value;
                },
              ),
            
              
              TextFormField(
                initialValue: productos.nombre,
                decoration: const InputDecoration(labelText: 'nombre'),
                onChanged: (value) {
                  productos.nombre = value;
                },
              ),
           
            
              TextFormField(
                initialValue: productos.descripcion,
                decoration: const InputDecoration(labelText: 'Descripcion'),
                onChanged: (value) {
                  productos.descripcion = value;
                },
              ),
              TextFormField(
                initialValue: productos.estado,
                decoration: const InputDecoration(labelText: 'Estado'),
                onChanged: (value) {
                productos.estado = value;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Aquí puedes guardar los cambios en la API y cerrar el modal.
                  _saveChangesAndCloseModal(productos);
                },
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        );
      },
    );
  }

  //GUARDA LOS CAMBIOS EN LA API

  void _saveChangesAndCloseModal(Producto productos) async {
    // Construye el cuerpo de la solicitud con los datos actualizados.
    Map<String, dynamic> requestBody = {
      "id": productos.id,
      "nombre": productos.nombre,
    
      "descripcion": productos.descripcion,
      "estado": productos.estado,
    };

    try {
      String url =
          "https://apisflutter.onrender.com/api/producto${productos.nombre}";

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
      _selectedProducto = null;
    });

    Navigator.of(context).pop(); // Cierra el modal.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 196, 81, 231),
        
        title: const Center(
          child: Text('Listado de productos'),
        ),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
           
          ),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final producto = productos[index];
                      return ListTile(
                        title: Column(
                          children: [
                            Text("Id: ${productos[index].id}"),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Nombre: ${productos[index].nombre}"),
                            Text("Precio: ${productos[index].precio}"),
                            Text("Cantidad: ${productos[index].cantidad}"),
                            Text("Descripcion: ${productos[index].descripcion}"),
                            Text("Estado: ${productos[index].estado}"),
                          
                          ],
                        ),
                        

                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Abre el modal de edición cuando se toca el botón de edición.
                            setState(() {
                              _selectedProducto = producto;
                            });
                            _showEditModal(producto);
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
