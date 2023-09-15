// import 'dart:html';
// import 'dart:js';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// validarDatos()async{
//      try{
//       CollectionReference ref= FirebaseFirestore.instance.collection('clientes');
//       QuerySnapshot usuario=await ref.get();

//       if(usuario.docs.length!=0){
//        for(var cursor in usuario.docs){
//         if(cursor.get('user')==_controller1.text&&cursor.get('password')==_controller2.text){

//          Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               const CompraPage(
//                                                 title: 'Compras',
//                                               )),
//                                     );
//         }
//       else{
//          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                       content: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: const <Widget>[
//                                           Icon(
//                                             Icons.warning_rounded,
//                                             color: Color.fromARGB(
//                                                 255, 255, 255, 255),
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text(
//                                             "No hay datos registrados",
//                                             style: TextStyle(
//                                                 color: Color.fromARGB(
//                                                     255, 255, 255, 255)),
//                                           )
//                                         ],
//                                       ),
//                                       duration:
//                                           const Duration(milliseconds: 2000),
//                                       width: 300,
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 8.0, vertical: 10),
//                                       behavior: SnackBarBehavior.floating,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(3.0),
//                                       ),
//                                       backgroundColor: Colors.red,
//                                     ));
//         }
//        }
//       }
//       }catch(e){
       
//        print('ERROR...'+e.toString());

// }
// }