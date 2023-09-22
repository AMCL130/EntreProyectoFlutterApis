import 'package:apis_proyecto/screen_views/screen/camara.dart';
import 'package:apis_proyecto/screen_views/screen/gps.dart';
import 'package:flutter/material.dart';
import 'package:apis_proyecto/screen_views/screen/clientes_screen.dart';
import 'package:apis_proyecto/screen_views/screen/productos_screen.dart';

class Pagina_principalApp extends StatelessWidget {
  const Pagina_principalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Pagina_principal(),
    );
  }
}

class Pagina_principal extends StatefulWidget {
  const Pagina_principal({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Pagina_principalState createState() => _Pagina_principalState();
}

class _Pagina_principalState extends State<Pagina_principal> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePagetres(),
    const HomePagedos(),
    const HomePageuno(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits_outlined),
            label: 'productos',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: const Color.fromARGB(255, 126, 52, 168),
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePagetres extends StatelessWidget {
  const HomePagetres({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 196, 81, 231),
        title: Row(
          children: <Widget>[
            const Expanded(
              child: Center(
                child: Text('Inicio'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {          
                 final route = MaterialPageRoute(
                    builder: (context) => const Camara());
                Navigator.push(context, route);           
              },
            ),
            IconButton(
              icon: Icon(Icons.map_outlined),
              onPressed: () {
                 final route = MaterialPageRoute(
                    builder: (context) => const Gps());
                Navigator.push(context, route);        
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Decoraciones LT'),
      ),
    );
  }
}
