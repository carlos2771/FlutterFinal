// import 'package:flutter/material.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';

// class EnviarMensajes extends StatelessWidget {
//   const EnviarMensajes({Key? key}) : super(key: key);

//   Future<void> sendMail() async {
//     String username = 'cadiaz5209@misena.edu.co';
//     String password = 'pnav xigr wbvv htzj';

//     final smtpServer = gmail(username, password);

//     final message = Message()
//       ..from = Address(username, 'Automatico')
//       ..recipients.add('carlosgamerki412@gmail.com')
//       ..ccRecipients.addAll(['carlosgameki412@gmail.com', 'carlosgameki412@gmail.com'])
//       ..bccRecipients.add(Address('carlosgameki412@gmail.com'))
//       ..subject = 'Mensaje de pruebas :: 😀 :: ${DateTime.now()}'
//       ..text = 'Este es un mensaje de prueba.'
//       ..html = "Hola aquí se está validando un mensaje de prueba";

//     try {
//       final sendReport = await send(message, smtpServer);
//       print('Message sent: ' + sendReport.toString());
//     } on MailerException catch (e) {
//       print('Message not sent.');
//       for (var p in e.problems) {
//         print('Problem: ${p.code}: ${p.msg}');
//       }
//     }

//     var connection = PersistentConnection(smtpServer);

//     // Send the first message
//     await connection.send(message);

//     // Close the connection
//     await connection.close();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ButtonStyle style =
//         ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
          
//           ElevatedButton(
//             style: style,
//             onPressed: null,
//             child: const Text('Disabled'),
//           // ),
//           _buildTextField(
//                 emailC,
//                 "Nombre",
//                 enabled: false,
//               ),
//           const SizedBox(height: 30),
//           ElevatedButton(
//             style: style,
//             onPressed: sendMail,
//             child: const Text('Enviar Mensaje'),
//           ),
//         ],
//       ),
//     );
//   }
// }
