import 'package:flutter/material.dart';
import 'package:clientes/services/firebase_services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Clientes",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getClientes(),
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos'));
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return const Center(child: Text('No hay clientes disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final cliente = snapshot.data[index];
                return Dismissible(
                  key: Key(cliente["uid"]),
                  onDismissed: (direction) async {
                    await deleteCliente(cliente["uid"]);
                    setState(() {
                      snapshot.data.removeAt(index);
                    });
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                              "¿Está seguro de querer eliminar a ${cliente["nombre"]}?"),
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
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${cliente["nombre"]} ${cliente["apellido"]}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            "Teléfono: ${cliente["telefono"]}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Color.fromARGB(255, 2, 2, 2),
                            ),
                          ),
                          Text(
                            "Email: ${cliente["email"]}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Text(
                            "Documento: ${cliente["documento"]}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/citas",
                                  arguments: {
                                    "uid": cliente["uid"],
                                    "nombre": cliente["nombre"],
                                    "documento": cliente["documento"],
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(
                                  8.0), // Ajusta el tamaño del botón
                              primary: Colors.black,
                              minimumSize:
                                  Size(100, 40), // Ajusta el tamaño mínimo
                            ),
                            child: const Text(
                              "Agendar",
                              style: TextStyle(
                                  fontSize: 14), // Ajusta el tamaño del texto
                            ),
                          ),
                          const SizedBox(
                              width: 8.0), // Añade espacio entre los botones
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/email",
                                  arguments: {
                                    "email": cliente["email"],
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              padding:const  EdgeInsets.all(
                                  8.0), // Ajusta el tamaño del botón
                              primary: Colors.black,
                              minimumSize:
                                  Size(100, 40), // Ajusta el tamaño mínimo
                            ),
                            child: const Text(
                              "Moto Lista",
                              style: TextStyle(
                                  fontSize: 14), // Ajusta el tamaño del texto
                            ),
                          ),
                        ],
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
        backgroundColor: Colors.black,
        children: [
          SpeedDialChild(
            label: 'Agregar cliente',
            onTap: () async {
              await Navigator.pushNamed(context, "/add");
              setState(() {});
            },
          ),
          SpeedDialChild(
            label: 'Citas',
            onTap: () async {
              await Navigator.pushNamed(context, "/homecitas");
              setState(() {});
            },
          ),
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
