// import 'package:apis_proyecto/Modelos/modelo_producto.dart';
import 'package:apis_proyecto/apis/api_productos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePageuno extends StatefulWidget {
  const HomePageuno({Key? key}) : super(key: key);

  @override
  State<HomePageuno> createState() => _HomePageunoState();
}

class _HomePageunoState extends State<HomePageuno> {
  int _currentIndex = 0;
  bool _isLoading = true;
  List<Producto> productos = [];
  Producto? _selectedProducto;
 
  bool _modalOpen = false;

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
        return AlertDialog(
            title: const Text('Editar Producto'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
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
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  onChanged: (value) {
                    productos.nombre = value;
                  },
                ),
                TextFormField(
                  initialValue: productos.precio.toString(),
                  decoration: const InputDecoration(labelText: 'Precio'),
                   onChanged: (value) {
                    productos.precio= double.parse(value);
                  },
                ),
                TextFormField(
                  initialValue: productos.cantidad.toString(),
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                  onChanged: (value) {
                    productos.cantidad = int.parse(value);
                  },
                ),
                TextFormField(
                  initialValue: productos.descripcion,
                  decoration: const InputDecoration(labelText: 'Descripción'),
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
            )));
      },
    );
  }

  //GUARDA LOS CAMBIOS EN LA API

  void _saveChangesAndCloseModal(Producto productos) async {
    // Construye el cuerpo de la solicitud con los datos actualizados.
    Map<String, dynamic> requestBody = {
      "_id": productos.id,
      "nombre": productos.nombre,
      "precio": productos.precio,
      "cantidad": productos.cantidad,
      "descripcion": productos.descripcion,     
      "estado": productos.estado,
    
    };

    try {
      String url = "https://apisflutter.onrender.com/api/producto";

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
      _selectedProducto = null;
    });

    Navigator.of(context).pop();
  }

  void _deleteProducto(producto) async {
    try {
      String url = "https://apisflutter.onrender.com/api/producto";
      http.Response res = await http.delete(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'_id': producto}));
      if (res.statusCode == 200) {
        // El registro se eliminó correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto eliminado correctamente')),
        );
        _getData();
      } else {
        // Se produjo un error al eliminar el registro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el producto')),
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
                child: Text('Listado de Productos'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: AlertDialog(
                        title: const Center(child: Text("Crear producto")),
                        content: Column(children: [CrearProductoApi()]),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: const Text('Cerrar'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
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
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final producto = productos[index];
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
                                      text: productos[index].id,
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
                                      text: 'Nombre: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: productos[index].nombre,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Precio: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: productos[index].precio.toString(),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Cantidad: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: productos[index].cantidad.toString(),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Descripción: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: productos[index].descripcion,
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
                                      text: productos[index].estado,
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
                                  _selectedProducto = producto;
                                });
                                _showEditModal(producto);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.purple,
                              ),
                              onPressed: () {
                                // Abre el modal de edición cuando se toca el botón de edición.
                                _deleteProducto(producto.id);
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
