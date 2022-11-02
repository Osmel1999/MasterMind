import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Preferencias/sharedPeference.dart';
import 'Firebase/fire_store.dart';

class BigData with ChangeNotifier {
  final pref = PreferenciasUsuario();

  Map<String, dynamic> bigData = {};

  Map<String, dynamic> d2B = {};

  DateTime now = DateTime.now();

  late int? numWeek;

  BigData() {
    load();
  }

  load() {
    bigData.isEmpty
        ? bigData = (pref.bigData.isNotEmpty)
            ? json.decode(pref.bigData)
            : {
                "Agenda": {},
                "Sueños": {},
                "Compromisos": {},
                "User": {},
                "Membresia": {},
                "Equipo": {},
                "Metas": {},
                "Progreso": {},
              }
        : null;
  }

  Map<String, String> toMig = {
    "Datos Agenda": "Agenda",
    "Datos Compromisos": "Compromisos",
    // "Datos Contactos",
    "Datos Personales": "User",
    "Datos Progreso": "Progreso",
    "Mapa Sueños": "sueños",
    "Membresia": "Membresia",
    "Nombres Team": "Equipo",
  };

  Future<void> migData(FireStore fireStore, String email) async {
    List keys = toMig.keys.toList();
    for (int i = 0; i < toMig.length; i++) {
      bigData[toMig[keys[i]]!] = await fireStore.bajarDataCloud(email, keys[i]);
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
    // if (bigData["Sueños"] == null) bigData["Sueños"] = {};
    if (bigData["Sueños"][key] == null) {
      bigData["Sueños"][key] = value;
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  deleteDream({required String key}) async {
    bigData["Sueños"].removeWhere((k, v) => key == k);
    notifyListeners();
  }

  selectedRango(String rango) {
    // if (bigData["Metas"] == null) bigData["Metas"] = {};
    bigData["Metas"]["Rango"] = rango;
    notifyListeners();
  }

  save() {
    pref.bigData = json.encode(bigData);
  }

  addProgress(String key, int value) {
    String current = weekIndicator(DateTime.parse("2022-10-28"));
    if (bigData["Progreso"][current] == null) bigData["Progreso"][current] = {};
    addAction(key, current);
    save();
    // notifyListeners();
  }

  addAction(String action, String current) {
    // String current = weekIndicator(DateTime.parse("2022-10-28"));
    if (bigData["Progreso"][current]["activity"] == null) {
      bigData["Progreso"][current]["activity"] = {};
    }
    // Revisamos que accion es la ejecutada
    if (action == "call") {
      if (bigData["Progreso"][current]["activity"]["call"] == null) {
        bigData["Progreso"][current]["activity"]["call"] = 0;
      }
      bigData["Progreso"][current]["activity"]["call"] =
          bigData["Progreso"][current]["activity"]["call"] + 1;
      // PLAN
    } else if (action == "plan") {
      if (bigData["Progreso"][current]["activity"]["plan"] == null) {
        bigData["Progreso"][current]["activity"]["plan"] = 0;
      }
      bigData["Progreso"][current]["activity"]["plan"] =
          bigData["Progreso"][current]["activity"]["plan"] + 1;
      // FOLLOW
    } else if (action == "follow") {
      if (bigData["Progreso"][current]["activity"]["follow"] == null) {
        bigData["Progreso"][current]["activity"]["follow"] = 0;
      }
      bigData["Progreso"][current]["activity"]["follow"] =
          bigData["Progreso"][current]["activity"]["follow"] + 1;
      // PLANIFICACION
    } else if (action == "planificacion") {
      if (bigData["Progreso"][current]["activity"]["planificacion"] == null) {
        bigData["Progreso"][current]["activity"]["planificacion"] = 0;
      }
      bigData["Progreso"][current]["activity"]["planificacion"] =
          bigData["Progreso"][current]["activity"]["planificacion"] + 1;
    }
  }

  String weekIndicator(DateTime init) {
    // Recorrer todas las fechas de las 13 semanas de la meta.
    // Mientras que la fecha actual sea menor que la semana en la (i) seguimos a la siguiente
    // si no es menor entonces grabamos los daros en esa semana.
    // DateTime currentWeek = now;
    while (now.isAfter(init)) {
      init = DateTime(init.year, init.month, init.day + 7);
    }
    return "${init.year}${init.month}${init.day}";
  }

  changeMentor(String query) {
    bool ok = (query.contains("@") && query.contains(".com"));
    if (query.isNotEmpty && ok) {
      bigData["User"]["Mentor"] = query;
      notifyListeners();
    } else if (!ok) {
      bigData["User"].remove("Mentor");
      notifyListeners();
    }
  }
}
