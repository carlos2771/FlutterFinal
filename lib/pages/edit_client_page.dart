import 'package:flutter/material.dart';
import 'package:clientes/services/firebase_services.dart';

class EditCliente extends StatefulWidget {
  const EditCliente({Key? key});

  @override
  State<EditCliente> createState() => _EditClienteState();
}

class _EditClienteState extends State<EditCliente> {
  TextEditingController nombreController = TextEditingController(text: "");
  TextEditingController apellidoController = TextEditingController(text: "");
  TextEditingController telefonoController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController documentoController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    nombreController.text = arguments["nombre"];
    apellidoController.text = arguments["apellido"];
    telefonoController.text = arguments["telefono"];
    emailController.text = arguments["email"];
    documentoController.text = arguments["documento"];
    passwordController.text = arguments["password"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Editar cliente", textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(nombreController, "Nombre", _validateText),
                _buildTextField(apellidoController, "Apellido", _validateText),
                _buildTextField(telefonoController, "Teléfono", _validatePhone),
                _buildTextField(emailController, "Email", _validateEmail),
                _buildTextField(documentoController, "Documento", _validateNumber),
                _buildTextField(passwordController, "Nueva contraseña", _validatePassword),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await updateCliente(
                        arguments["uid"],
                        nombreController.text,
                        apellidoController.text,
                        telefonoController.text,
                        emailController.text,
                        documentoController.text,
                        passwordController.text,
                      ).then((_) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: const Text("Actualizar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (!isNumeric(value)) {
      return 'Ingrese un número válido';
    }
    return null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (!isNumeric(value)) {
      return 'Ingrese un número válido';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (!value.contains('@')) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText,
    String? Function(String?)? validator,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  bool isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }
}
