import 'package:clientes/pages/citas/home_citas_page.dart';
import 'package:clientes/pages/clientes/home_page_cliente.dart';
import 'package:clientes/pages/home_pages.dart';
import 'package:clientes/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Part 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyLoginPage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key, required this.title});
  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  validarDatos() async {
    try {
      CollectionReference ref = FirebaseFirestore.instance.collection("clientes");
      QuerySnapshot usuario = await ref.get();

      if (usuario.docs.isNotEmpty) {
        for (var cursor in usuario.docs) {
          if (_controller1.text == "admin" && _controller2.text == "admin") {
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
            return;
          }
          if (cursor.get('email') == _controller1.text &&
              cursor.get('password') == _controller2.text) {
            final clienteFuture = getClientePorEmail(_controller1.text); // Llama a la función para obtener los datos del cliente
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClienteView(
                  email: _controller1.text,
                  clienteFuture:
                      clienteFuture, // Pasa el clienteFuture obtenido
                ),
              ),
            );
            return;
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                Icon(
                  Icons.warning_rounded,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "No se encontró el usuario o contraseña incorrecta",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
            duration: const Duration(milliseconds: 2000),
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                Icon(
                  Icons.warning_rounded,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "No hay datos registrados",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
            duration: const Duration(milliseconds: 2000),
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('ERROR...' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: _controller1,
                        decoration: InputDecoration(
                          hintText: 'Correo',
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.w600),
                          fillColor: Colors.grey.shade200,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese un email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: _controller2,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Contraseña',
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.w600),
                          fillColor: Colors.grey.shade200,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese una contraseña';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              validarDatos();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.black, // background (button) color
                            foregroundColor:
                                Colors.white, // foreground (text) color
                          ),
                          child: const Text('Iniciar sesión'),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const Text('¿No tienes una cuenta?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/register");
                          },
                          child: const Text(
                            'Registrarse',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
