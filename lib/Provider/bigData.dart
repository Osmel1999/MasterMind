import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Preferencias/sharedPeference.dart';
import 'Firebase/fire_store.dart';

class BigData with ChangeNotifier {
  final pref = PreferenciasUsuario();

  Map<String, dynamic> bigData = {};

  Map<String, dynamic> d2B = {};

  List toMig = [
    "Datos Agenda",
    "Datos Compromisos",
    // "Datos Contactos",
    "Datos Personales",
    "Datos Progreso",
    "Mapa Sueños",
    "Membresia",
    "Nombres Team",
  ];

  Future<void> migData(FireStore fireStore, String email) async {
    for (int i = 0; i < toMig.length; i++) {
      bigData[toMig[i]] = await fireStore.bajarDataCloud(email, toMig[i]);
      fireStore.deleteOldDoc(
        nombreColeccionDatos: email,
        doc: toMig[i],
      );
    }
  }

  Future<void> uploadMigData(FireStore fireStore, String email) async {
    if (bigData.isNotEmpty) {
      // Guardo en el dispositivo
      pref.bigData = jsonEncode(bigData);
      // La subo al nuevo modelo en la nube
      fireStore.updateDataCloud("UsersData", email, bigData);
    }
  }

  Future<bool> addDream({required String key, required String value}) async {
    if (bigData["db_sueños"] == null) bigData["db_sueños"] = {};
    if (bigData["db_sueños"][key] == null) {
      bigData["db_sueños"][key] = value;
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  deleteDream({required String key}) async {
    bigData["db_sueños"].removeWhere((k, v) => key == k);
    notifyListeners();
  }

  selectedRango(String rango) {
    if (bigData["metas"] == null) bigData["metas"] = {};
    bigData["metas"]["rango"] = rango;
    notifyListeners();
  }

  save() {
    pref.bigData = json.encode(bigData);
    print(pref.bigData);
  }
}
