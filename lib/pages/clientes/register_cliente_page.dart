import 'package:clientes/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class RegisterCliente extends StatefulWidget {
  const RegisterCliente({Key? key});

  @override
  State<RegisterCliente> createState() => _RegisterClienteState();
}

class _RegisterClienteState extends State<RegisterCliente> {
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

  // Validación de números
  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (!isNumeric(value)) {
      return 'Ingrese un número válido';
    }
    return null;
  }

  // Validación de texto genérica para campos obligatorios
  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
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
              _buildTextField(telefonoController, "Teléfono", maxLength: 11, validator: _validateNumber, ),
              _buildTextField(emailController, "Email", validator: _validateEmail),
              _buildTextField(documentoController, "Documento", validator: _validateNumber),
              _buildTextField(password1Controller, "Contraseña", validator: _validatePassword, obscureText: true),
              _buildTextField(password2Controller, "Confirmar Contraseña", validator: _validatePasswordConfirmation, obscureText: true),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Tu código de acción aquí
                    await addCliente(
                      nombreController.text,
                      apellidoController.text,
                      telefonoController.text,
                      emailController.text,
                      documentoController.text,
                      password1Controller.text,
                    ).then((_) async {
                      // Envía el correo electrónico de bienvenida
                      await _enviarCorreo(emailController.text);
                      // Navega de vuelta a la pantalla de inicio o realiza alguna otra acción
                      Navigator.pushNamed(context, "/");
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
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: "Ingrese su $labelText",
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

  Future<void> _enviarCorreo(String recipientEmail) async {
    String username = 'cadiaz5209@misena.edu.co'; // Reemplaza con tu dirección de correo
    String password = 'pnav xigr wbvv htzj'; // Reemplaza con tu contraseña de correo

    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Automático')
      ..recipients.add(recipientEmail)
      ..ccRecipients.addAll([recipientEmail, recipientEmail])
      ..bccRecipients.add(Address(recipientEmail))
      ..subject = '¡Bienvenido a la aplicación!'
      ..html = 'Hola, $recipientEmail, ¡te has registrado en nuestra aplicación!';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

    var connection = PersistentConnection(smtpServer);

    // Send the first message
    await connection.send(message);

    // Close the connection
    await connection.close();
  }
}
