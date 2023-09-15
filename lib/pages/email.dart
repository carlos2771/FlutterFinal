import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() => runApp(const MyApp());

class EnviarMensajes extends StatelessWidget {
   EnviarMensajes({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<void> enviarCorreo(BuildContext context) async {
    final Map arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    TextEditingController emailController =
        TextEditingController(text: arguments["email"]);

    String username = 'cadiaz5209@misena.edu.co'; // Reemplaza con tu dirección de correo
    String password = 'pnav xigr wbvv htzj'; // Reemplaza con tu contraseña de correo

    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Automático')
      ..recipients.add(emailController.text)
      ..ccRecipients.addAll([emailController.text, emailController.text])
      ..bccRecipients.add(Address(emailController.text))
      ..subject = 'Tu moto está lista para ser recogida 😀❤️‍🔥 ${DateTime.now()}'
      ..html = "Hola, ${emailController.text}, tu reparación ha sido exitosa";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());

      // Muestra un SnackBar con el mensaje "Mensaje enviado"
      scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: const Text('Mensaje enviado'),
          duration: const Duration(seconds: 3), // Puedes ajustar la duración aquí
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: Colors.blue, // Cambia el color de fondo del botón
      onPrimary: Colors.white, // Cambia el color del texto del botón
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Enviar Correo'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              style: style,
              onPressed: null,
              child: const Text('Disabled'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: style,
              onPressed: () => enviarCorreo(context),
              child: const Text('Enviar Correo'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home:  EnviarMensajes(),
    );
  }
}
