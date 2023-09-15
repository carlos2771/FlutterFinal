import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  
FlutterLocalNotificationsPlugin(); // instancia del paquete

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings("app_icon1");

  const DarwinInitializationSettings initializationSettingsIOS= 
  DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
  
  android: initializationSettingsAndroid, 
  iOS : initializationSettingsIOS,

  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> mostrarNotificacion() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails ("channelId", "channelName", importance: Importance.max, priority: Priority.high); // configuracion de la notificacion

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(1, "Moto lista", "recoje tu moto en nuestro taller ", notificationDetails);
}