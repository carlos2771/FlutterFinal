import 'package:clientes/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddCitas(),
    );
  }
}

class AddCitas extends StatefulWidget {
  const AddCitas({Key? key});

  @override
  State<AddCitas> createState() => _AddCitasState();
}

class _AddCitasState extends State<AddCitas> {
  TextEditingController fechaController = TextEditingController(text: "");
  TextEditingController placaController = TextEditingController(text: "");
  String selectedEstado = 'En proceso'; // Valor inicial para el estado
  TextEditingController servicioController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    TextEditingController nombreController = TextEditingController(text: arguments["nombre"]);
    TextEditingController documentoController = TextEditingController(text: arguments["documento"]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Cambia el color del AppBar a negro
        centerTitle: true, // Centra el texto del AppBar
        title: const Text(
          "Agendar Cita",
          style: TextStyle(
              color: Colors
                  .white), // Cambia el color del texto del AppBar a blanco
        ),
      ),
      body: SingleChildScrollView(
        // Agrega un SingleChildScrollView para permitir desplazamiento
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                enabled: false,
                controller: nombreController,
                decoration: const InputDecoration(
                  hintText: "Ingrese su nombre",
                ),
              ),
              TextField(
                controller: fechaController,
                decoration: const InputDecoration(
                  hintText: "Ingrese la fecha",
                ),
              ),
              TextField(
                controller: placaController,
                decoration: const InputDecoration(
                  hintText: "Ingrese la placa",
                ),
              ),
              TextField(
                enabled: false,
                controller: documentoController,
                decoration: const InputDecoration(
                  hintText: "Ingrese el documento",
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Limita a números
              ),
              DropdownButtonFormField<String>(
                value: selectedEstado,
                onChanged: (newValue) {
                  setState(() {
                    selectedEstado = newValue!;
                  });
                },
                items: <String>['En proceso', 'Listo'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  hintText: "Estado",
                ),
              ),
              TextField(
                controller: servicioController,
                decoration: const InputDecoration(
                  hintText: "Servicio",
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 20.0), // Espacio vertical interno
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await addCita(
                      nombreController.text,
                      fechaController.text,
                      placaController.text,
                      documentoController.text,
                      selectedEstado,
                      servicioController.text);
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, "/homecitas");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Cambia el color del botón a negro
                ),
                child: const Text(
                  "Guardar",
                  style: TextStyle(
                      color: Colors
                          .white), // Cambia el color del texto del botón a blanco
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
