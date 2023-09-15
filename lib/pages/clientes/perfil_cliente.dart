import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PerfilCliente extends StatefulWidget {
  const PerfilCliente({Key? key}) : super(key: key);

  @override
  State<PerfilCliente> createState() => _PerfilClienteState();
}

class _PerfilClienteState extends State<PerfilCliente> {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String nombre = arguments["nombre"];
    final String apellido = arguments["apellido"];
    final String telefono = arguments["telefono"];
    final String email = arguments["email"];
    final String documento = arguments["documento"];
    final String password = arguments["password"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi perfil"),
      ),
      body: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text("Nombre"),
              subtitle: Text(nombre),
            ),
            ListTile(
              title: Text("Apellido"),
              subtitle: Text(apellido),
            ),
            ListTile(
              title: Text("Teléfono"),
              subtitle: Text(telefono),
            ),
            ListTile(
              title: Text("Email"),
              subtitle: Text(email),
            ),
            ListTile(
              title: Text("Documento"),
              subtitle: Text(documento),
            ),
            ListTile(
              title: Text("Contraseña"),
              subtitle: Text(password),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Aquí puedes agregar la lógica para actualizar los datos si es necesario
                },
                child: const Text("Actualizar"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            label: 'Agregar cita',
            onTap: () async {
              await Navigator.pushNamed(context, "/citas");
              setState(() {});
            },
          ),
          SpeedDialChild(
            label: 'Citas',
            onTap: () async {
              await Navigator.pushNamed(context, "/homecitas", arguments: {
                "uid": arguments["uid"], // Pasa el UID del cliente a la vista de citas
                "nombre": nombre, // Pasa el nombre del cliente a la vista de citas
              });
              setState(() {});
            },
          ),
          SpeedDialChild(
            label: 'Regresar',
            onTap: () async {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
