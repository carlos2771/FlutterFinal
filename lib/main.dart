import 'package:clientes/pages/citas/add_citas_page.dart';
import 'package:clientes/pages/citas/edit_cita_page.dart';

import 'package:clientes/pages/citas/home_citas_page.dart';
import 'package:clientes/pages/clientes/citas_cliente.dart';
import 'package:clientes/pages/clientes/perfil_cliente.dart';
import 'package:clientes/pages/clientes/register_cliente_page.dart';
import 'package:clientes/pages/edit_client_page.dart';
import 'package:clientes/pages/email.dart';
import 'package:clientes/pages/login/login_client_page.dart';
import 'package:clientes/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:clientes/pages/add_client_page.dart';
import 'package:clientes/pages/home_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initNotifications(); // para que se ejecute como middleware
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "material App",
      initialRoute: "/",
      routes: {

        "/":(context) => const MyLoginPage(title: 'Hola munds',),
        "/homepage": (context) => const Home(),
        
        "/add": (context) => const AddCliente(),
        "/edit": (context) => const EditCliente(),
        //citas
        "/homecitas": (context) => const  HomeCitas(),
        "/citas": (context) => const AddCitas(),
        "/editcita" : (context) => const EditCitas(),
        // "/notification": (context) => const Notification(),

        //Register Cliente
        "/register" :(context) => const RegisterCliente(),
        "/perfil" :(context) => const PerfilCliente(),
        "/citascliente" :(context) => const AddCitasClient(),
        "/email" :(context) => EnviarMensajes(),

        

    
      },
    );
     
  }
}