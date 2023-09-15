import 'package:clientes/services/firebase_services.dart';
import 'package:clientes/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeCitas extends StatefulWidget {
  const HomeCitas({Key? key});

  @override
  State<HomeCitas> createState() => _HomeState();
}

class _HomeState extends State<HomeCitas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Cambia el color del AppBar a negro
        centerTitle: true, // Centra el texto del AppBar
        title: const Text(
          "Agenda de Citas",
          style: TextStyle(color: Colors.white), // Cambia el color del texto del AppBar a blanco
        ),
      ),
      body: FutureBuilder(
        future: getCitas(),
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los datos'));
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(child: Text('No hay clientes disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final citas = snapshot.data[index];
                return Dismissible(
                  key: Key(citas["uid"]),
                  onDismissed: (direction) async {
                    await deleteCita(citas["uid"]);
                    setState(() {
                      snapshot.data.removeAt(index);
                    });
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("¿Está seguro de querer eliminar a ${citas["nombre"]}?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text("Sí, estoy seguro"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete),
                  ),
                  direction: DismissDirection.endToStart,
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                        "Nombre: ${citas["nombre"]}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Fecha: ${citas["fecha"]}\nPlaca: ${citas["placa"]}\nDocumento: ${citas["documento"]}\nEstado: ${citas["estado"]}\nServicio: ${citas["servicio"]}"),
                      onTap: () async {
                        await Navigator.pushNamed(context, "/editcita", arguments: {
                          "uid": citas["uid"],
                          "nombre": citas["nombre"],
                          "fecha": citas["fecha"],
                          "placa": citas["placa"],
                          "documento": citas["documento"],
                          "estado": citas["estado"],
                          "servicio": citas["servicio"]
                        });
                        setState(() {});
                      },
                      trailing: ElevatedButton(
                        onPressed: () {
                          mostrarNotificacion();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Cambia el color del botón a negro
                        ),
                        child: const Text("Notificar", style: TextStyle(color: Colors.white)), // Cambia el color del texto del botón a blanco
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }),
      ),
      floatingActionButton: SpeedDial(
        
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor:
            Colors.black,
        children: [
          SpeedDialChild(
            label: 'Clientes',
            onTap: () async {
              await Navigator.pushNamed(context, "/homepage");
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
