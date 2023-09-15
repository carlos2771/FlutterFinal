import 'package:clientes/pages/clientes/mi_cita.dart';
import 'package:clientes/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ClienteView extends StatefulWidget {
  final Future<Map<String, dynamic>?> clienteFuture;
  final String email;

  ClienteView({required this.clienteFuture, required this.email});

  @override
  _ClienteViewState createState() => _ClienteViewState();
}

class _ClienteViewState extends State<ClienteView> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Cambia el color del AppBar a negro
        centerTitle: true, // Centra el texto del AppBar
        title: const Text(
          'Tu Perfil',
          style: TextStyle(
            color: Colors.white, // Cambia el color del texto del AppBar a blanco
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: widget.clienteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('No se encontró un cliente con el email ${widget.email}'),
            );
          } else {
            final cliente = snapshot.data!;
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1604260324056-45f7c778754a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8dGFsbGVyJTIwZGUlMjBtb3Rvc3xlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80'), // Reemplaza con la URL de tu imagen de fondo
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nombre: ${cliente["nombre"]}',
                              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Text('Apellido: ${cliente["apellido"]}'),
                            Text('Teléfono: ${cliente["telefono"]}'),
                            Text('Email: ${cliente["email"]}'),
                            Text('Documento: ${cliente["documento"]}'),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.pushNamed(context, "/edit", arguments: {
                          "uid": cliente["uid"],
                          "nombre": cliente["nombre"],
                          "apellido": cliente["apellido"],
                          "telefono": cliente["telefono"],
                          "email": cliente["email"],
                          "documento": cliente["documento"],
                          "password": cliente["password"],
                        });
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // Cambia el color del botón a negro
                      ),
                      child: const Text("Editar Perfil", style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final citaFuture = getCitaPorDocumento(cliente["documento"]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CitaView(
                              documento: cliente["documento"],
                              citaFuture: citaFuture,
                            ),
                          ),
                        );     
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // Cambia el color del botón a negro
                      ),
                      child: const Text("Mis Citas", style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/citascliente", arguments: {
                          "uid": cliente["uid"],
                          "nombre": cliente["nombre"],
                          "documento": cliente["documento"],
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // Cambia el color del botón a negro
                      ),
                      child: const Text("Agendar Cita", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
         backgroundColor:
            Colors.black,
        children: [
          SpeedDialChild(
            label: 'Salir',
            onTap: () async {
              await Navigator.pushNamed(context, "/");
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
