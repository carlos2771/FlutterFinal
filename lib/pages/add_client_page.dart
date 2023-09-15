import 'package:flutter/material.dart';
import 'package:clientes/services/firebase_services.dart';

class AddCliente extends StatefulWidget {
  const AddCliente({Key? key});

  @override
  State<AddCliente> createState() => _AddClienteState();
}

class _AddClienteState extends State<AddCliente> {
  TextEditingController nombreController = TextEditingController(text: "");
  TextEditingController apellidoController = TextEditingController(text: "");
  TextEditingController telefonoController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController documentoController = TextEditingController(text: "");
  TextEditingController password1Controller = TextEditingController(text: "");
  TextEditingController password2Controller = TextEditingController(text: "");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Validación de correo electrónico
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese un correo electrónico';
    }
    if (!value.contains('@')) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  // Validación de contraseña
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese una contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  // Validación de confirmación de contraseña
  String? _validatePasswordConfirmation(String? value) {
    if (value != password1Controller.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  // Validación de campo de texto no vacío
  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  // Validación de número de teléfono
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (value.length != 10 || !isNumeric(value)) {
      return 'Ingrese un número de teléfono válido';
    }
    return null;
  }

  // Validación de número de documento
  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (!isNumeric(value)) {
      return 'Ingrese un número válido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Agregar Cliente",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(nombreController, "Nombre", validator: _validateText),
              _buildTextField(apellidoController, "Apellido", validator: _validateText),
              _buildTextField(telefonoController, "Teléfono", maxLength: 10, validator: _validatePhone),
              _buildTextField(emailController, "Email", validator: _validateEmail),
              _buildTextField(documentoController, "Documento", validator: _validateNumber),
              _buildTextField(password1Controller, "Contraseña", validator: _validatePassword, obscureText: true),
              _buildTextField(password2Controller, "Confirmar Contraseña", validator: _validatePasswordConfirmation, obscureText: true),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await addCliente(
                      nombreController.text,
                      apellidoController.text,
                      telefonoController.text,
                      emailController.text,
                      documentoController.text,
                      password1Controller.text,
                    ).then((_) {
                      Navigator.pushNamed(context, "/homepage", arguments:  {
                        "email" : emailController.text
                      });
                      setState(() {});
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: const Text(
                  "Guardar",
                  style: TextStyle(
                    color: Colors.white,
                  ),
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
    int? maxLength,
    String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        validator: validator,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: "Ingrese su $labelText",
          border: const OutlineInputBorder(),
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
