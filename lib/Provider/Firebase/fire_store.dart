import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Preferencias/sharedPeference.dart';

class FireStore with ChangeNotifier {
  final databaseReference = FirebaseFirestore.instance;
  String endpoint = "UsersData";

  subirDataCloud(String nombreColeccionDatos, String nombreDocumento,
      Map<String, dynamic> modelDatos) async {
    await databaseReference
        .collection(nombreColeccionDatos)
        .doc(nombreDocumento)
        .set(modelDatos);
    print('----- ALL WORKS -----');
    return true;
  }

  Future<Map<String, dynamic>> bajarDataCloud(
      String nombreColeccionDatos, String docName) async {
    Map<String, dynamic>? mapaDataDescargada = {};

    await databaseReference
        .collection(nombreColeccionDatos)
        .doc(docName)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      mapaDataDescargada = documentSnapshot.data() as Map<String, dynamic>?;
    });
    return mapaDataDescargada ?? {};
    // globalBloC.dataUsuario.datosProgressPartner = mapaDataDescargada;
  }

  Future<Map<String, dynamic>> bajarDatosAgenda(
      String nombreColeccionDatos, String docName) async {
    late Map<String, dynamic>? mapaDataDescargada;

    await databaseReference
        .collection(nombreColeccionDatos)
        .doc(docName)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      mapaDataDescargada = documentSnapshot.data() as Map<String, dynamic>?;
    });

    print('===== DATOS AGENDA DESCARGADOS ======');
    return mapaDataDescargada!;
    // globalBloC.dataUsuario.datosProgressPartner = mapaDataDescargada;
  }

  updateDataCloud(
      String nombreColeccionDatos, String docName, Map<String, dynamic> data) {
    databaseReference
        .collection(nombreColeccionDatos)
        .doc(docName)
        .set(data, SetOptions(merge: true));
    print('===== DATA ACTUALIZADA =====');
  }

  deleteDataCloud(
      {String? nombreColeccionDatos, String? docName, String? key}) {
    databaseReference
        .collection(nombreColeccionDatos!)
        .doc(docName)
        .update({key!: FieldValue.delete()})
        .then((value) => print('Data Deleted'))
        .catchError(
            (error) => print("Failed to delete user's property: $error"));
  }

  deleteOldDoc({String? nombreColeccionDatos, String? doc}) {
    databaseReference
        .collection(nombreColeccionDatos!)
        .doc(doc)
        .delete()
        .then((value) => print('Data Deleted'))
        .catchError(
            (error) => print("Failed to delete user's property: $error"));
  }

  updateDataMentor(String mentor, Map<String, dynamic> data) {
    databaseReference
        .collection(endpoint)
        .doc(mentor)
        .set(data, SetOptions(merge: true));
    print('===== DATA ACTUALIZADA =====');
  }
}
