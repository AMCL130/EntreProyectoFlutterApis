// ignore: file_names
import 'package:flutter/material.dart';
import 'package:apis_proyecto/screen_views/principal.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();
  var usuario = 'mateo';
  var contrasena = 123;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 196, 81, 231),
        
        title: const Center(
          child: Text('Login Decoraciones Lina Tabares'),
        ),
      ),
      body: Center(
        child: Column(children: [
          // const CircleAvatar (
          //   // width: 200,
          //   // height: 200,
          //   // child: Image.asset('images/logo.png')
          //   backgroundImage: AssetImage('images/logo.png'),
          //   radius: 100,

          // ),

          SizedBox(
            height: 200,
            child: Image.network(
                'https://i.ibb.co/QYyw7JG/Logo-sobre-moda-femenina-minimalista-neutral.png'),
          ),

          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
            height: 50,
            child: TextField(
              controller: correoController,
              obscureText: false,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo electronico'),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 60.0,
            ),
            height: 50,
            child: TextField(
              controller: contrasenaController,
              obscureText: false,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Contraseña'),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.login,
              color: Color.fromARGB(255, 94, 3, 155),
            ),
            onPressed: () {
              final route =
                  MaterialPageRoute(builder: (context) => const Pagina_principal());
              Navigator.push(context, route);
            },
          )
        ]),
      ),
    );
  }
}
