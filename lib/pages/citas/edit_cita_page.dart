import 'package:clientes/services/firebase_services.dart';
import 'package:flutter/material.dart';

class EditCitas extends StatefulWidget {
  const EditCitas({Key? key});

  @override
  State<EditCitas> createState() => _EditClienteState();
}

class _EditClienteState extends State<EditCitas> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController placaController = TextEditingController();
  TextEditingController documentoController = TextEditingController();
  String selectedEstado = 'En proceso'; // Cambiando a String
  TextEditingController servicioController = TextEditingController();
  @override
 
  Widget build(BuildContext context) {
     final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    nombreController.text = arguments["nombre"];
    fechaController.text = arguments["fecha"];
    placaController.text = arguments["placa"];
    documentoController.text = arguments["documento"];
    servicioController.text = arguments["servicio"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Editar Cita",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField(
                nombreController,
                "Nombre",
                enabled: false,
              ),
              _buildTextField(
                fechaController,
                "Nueva fecha",
                hintText: "Ingrese la nueva fecha",
              ),
              _buildTextField(
                placaController,
                "Nueva placa",
                hintText: "Ingrese su nueva placa",
              ),
              _buildTextField(
                documentoController,
                "Documento",
                enabled: false,
                hintText: "Ingrese su nuevo documento",
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
                decoration: InputDecoration(
                  labelText: "Estado",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                servicioController,
                "Servicio",
                hintText: "Ingrese su servicio",
              ),
              ElevatedButton(
                onPressed: () async {
                  await updateCita(
                    arguments["uid"],
                    nombreController.text,
                    fechaController.text,
                    placaController.text,
                    documentoController.text,
                    selectedEstado,
                    servicioController.text,
                  ).then((_) {
                    Navigator.pop(context);
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: const Text(
                  "Actualizar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    bool enabled = true,
    String? hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
