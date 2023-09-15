import 'package:clientes/services/firebase_services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddCitasClient(),
    );
  }
}

class AddCitasClient extends StatefulWidget {
  const AddCitasClient({Key? key});

  @override
  State<AddCitasClient> createState() => _AddCitasClientState();
}

class _AddCitasClientState extends State<AddCitasClient> {
  TextEditingController fechaController = TextEditingController(text: "");
  TextEditingController placaController = TextEditingController(text: "");
  TextEditingController estadoController = TextEditingController(text: "En proceso");
  TextEditingController servicioController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    TextEditingController nombreController = TextEditingController(text: arguments["nombre"]);
    TextEditingController emailController = TextEditingController(text: arguments["email"]);
    TextEditingController documentoController = TextEditingController(text: arguments["documento"]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agendar Cita"),
        backgroundColor: Colors.black, // Color del AppBar
        centerTitle: true, // Centra el texto del AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildTextField("Ingrese su nombre", nombreController, enabled: false),
              buildTextField("Ingrese la fecha", fechaController),
              buildTextField("Ingrese la placa", placaController),
              buildTextField("Ingrese el documento", documentoController, enabled: false),
              buildTextField("Estado", estadoController),
              buildTextField("Servicio", servicioController, contentPadding: EdgeInsets.symmetric(vertical: 20.0)),
              ElevatedButton(
                onPressed: () async {
                  await addCita(
                    nombreController.text,
                    fechaController.text,
                    placaController.text,
                    documentoController.text,
                    estadoController.text,
                    servicioController.text,
                  );
                  Navigator.pop(context);
                },
                child: const Text("Guardar"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Color del botón
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller, {bool enabled = true, EdgeInsetsGeometry? contentPadding}) {
    return TextField(
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: contentPadding, // Espacio vertical interno
      ),
    );
  }
}
