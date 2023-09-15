import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
// import 'package:flutter/cupertino.dart';

FirebaseFirestore db = FirebaseFirestore.instance;


Future<List> getClientes() async {
  List clientes = [];
  CollectionReference collectionReference = db.collection("clientes");

  QuerySnapshot queryCliente = await collectionReference.get();
  for (var documento in queryCliente.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String,
        dynamic>; // documento.data devuelve lo que se realizo en la consulta que devuelve un map string que contiene los datos almacenados en el documento
    // fire store devuelve un Map<string, objet> entonces se castea con el as map para que devuelva un string dynamic y poder acceder a sus datos
    final cliente = {
      "uid": documento.id,
      "nombre": data["nombre"],
      "apellido": data["apellido"],
      "telefono": data["telefono"],
      "email": data["email"],
      "documento": data["documento"],
      "password": data["password"],
    };
    clientes.add(cliente);
  }
  return clientes;
}

//get citas
Future<List> getCitas() async {
  List citas = [];
  CollectionReference collectionReference = db.collection("citas");

  QuerySnapshot queryCliente = await collectionReference.get();
  for (var documento in queryCliente.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String,
        dynamic>; // documento.data devuelve lo que se realizo en la consulta que devuelve un map string que contiene los datos almacenados en el documento
    // fire store devuelve un Map<string, objet> entonces se castea con el as map para que devuelva un string dynamic y poder acceder a sus datos
    final cita = {
      "uid": documento.id,
      "nombre": data["nombre"],
      "documento": data["documento"],
      "fecha": data["fecha"],
      "placa": data["placa"],
      "estado": data["estado"],
      "servicio": data["servicio"],
    };
    citas.add(cita);
  }
  return citas;
}



// obtener una sola cita 
Future<Map<String, dynamic>?> getClientePorUid(String uid) async {
  try {
    CollectionReference collectionReference = db.collection("clientes");

    DocumentSnapshot documentSnapshot = await collectionReference.doc(uid).get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic> data = documentSnapshot.data()
          as Map<String, dynamic>;
      final cliente = {
        "uid": documentSnapshot.id,
        "nombre": data["nombre"],
        "apellido": data["apellido"],
        "telefono": data["telefono"],
        "email": data["email"],
        "documento": data["documento"],
        "password": data["password"],
      };
      return cliente;
    } else {
      // El cliente no existe
      return null;
    }
  } catch (error) {
    // Manejo de errores
    print('Error al obtener el cliente: $error');
    return null;
  }
}
// encontrar por documento 
Future<Map<String, dynamic>?> getClientePorEmail(String email) async {
  try {
    CollectionReference collectionReference = db.collection("clientes");

    QuerySnapshot querySnapshot =
        await collectionReference.where("email", isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      final Map<String, dynamic> data = documentSnapshot.data()
          as Map<String, dynamic>;
      final cliente = {
        "uid": documentSnapshot.id,
        "nombre": data["nombre"],
        "apellido": data["apellido"],
        "telefono": data["telefono"],
        "email": data["email"],
        "documento": data["documento"],
        "password": data["password"],
      };
      return cliente;
    } else {
      // El cliente no existe
      return null;
    }
  } catch (error) {
    // Manejo de errores
    print('Error al obtener el cliente: $error');
    return null;
  }
}







Future<Map<String, dynamic>?> getCitaPorDocumento(String documento) async {
  try {
    CollectionReference collectionReference = db.collection("citas");

    QuerySnapshot querySnapshot =
        await collectionReference.where("documento", isEqualTo: documento).get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      final Map<String, dynamic> data = documentSnapshot.data()
          as Map<String, dynamic>;
      final cita = {
        "uid": documentSnapshot.id,
        "nombre": data["nombre"],
        "fecha": data["fecha"],
        "placa": data["placa"],
        "estado": data["estado"],
        "servicio": data["servicio"],
      };
      return cita;
    } else {
      // La cita no existe
      return null;
    }
  } catch (error) {
    // Manejo de errores
    print('Error al obtener la cita: $error');
    return null;
  }
}





//añadir los datos
Future<void> addCliente(String nombre, String apellido, String telefono,
    String email, String documento, String passsword) async {
  await db.collection("clientes").add({
    "nombre": nombre,
    "apellido": apellido,
    "telefono": telefono,
    "email": email,
    "documento": documento,
    "password": passsword,
  });
}

//añadir citas
Future<void> addCita(String nombre, String fecha, String placa,  String documento, String estado,
    String servicio) async {
  await db.collection("citas").add({
    "nombre": nombre,
    "fecha": fecha,
    "placa": placa,
    "documento": documento,
    "estado": estado,
    "servicio": servicio,
  });
}

Future<void> updateCliente(String uid,String newNombre,String newApellido,String newTelefono,String newEmail,String newDocumento,String newPassword) async {
  await db.collection("clientes").doc(uid).set({
    "nombre": newNombre,
    "apellido": newApellido,
    "telefono": newTelefono,
    "email": newEmail,
    "documento": newDocumento,
    "password": newPassword,
  });
}

// update Cita
Future<void> updateCita(String uid, String newNombre, String newFecha,  String newPlaca, String newDocumento, String newEstado, String newServicio)
     async {
  await db.collection("citas").doc(uid).set({
    "nombre": newNombre,
    "fecha": newFecha,
    "placa": newPlaca,
    "documento" : newDocumento,
    "estado": newEstado,
    "servicio": newServicio,
  });
}



// Eliminar

Future<void> deleteCliente(String uid) async {
  await db.collection("clientes").doc(uid).delete();
}
//delete cita
Future<void> deleteCita(String uid) async {
  await db.collection("citas").doc(uid).delete();
}




// enviar correo 
