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
  String today = "";

  String respons = "";

  late int? numWeek;

  BigData() {
    load();
    today = "${now.year}-${now.month}-${now.day}";
  }

  load() {
    bigData.isEmpty
        ? bigData = (pref.bigData.isNotEmpty)
            ? json.decode(pref.bigData)
            : {
                "Sesion": "",
                "Agenda": {"2022-10-28": {}},
                "Sueños": {},
                "Contactos": {
                  "Prospectos": {},
                  "En espera": {},
                  "Clientes": {},
                  "Invitado": {},
                },
                "Compromiso": {
                  "init": "2022-10-28",
                },
                "User": {"Email": ""},
                "Membresia": {},
                "Equipo": {},
                "Metas": {},
                "Progreso": {},
              }
        : null;
    pref.bigData = jsonEncode(bigData);
  }

  Map<String, String> toMig = {
    "Datos Agenda": "Agenda",
    "Datos Compromisos": "Compromiso",
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

  String addAction(String key, int value) {
    String current =
        weekIndicator(DateTime.parse(bigData["Compromiso"]["init"]));
    if (bigData["Progreso"][current] == null) bigData["Progreso"][current] = {};
    addProgress(key, current);
    save();
    return key;
    // notifyListeners();
  }

  addProgress(String action, String current) {
    // String current = weekIndicator(DateTime.parse("2022-10-28"));
    if (bigData["Progreso"][current]["activity"] == null) {
      bigData["Progreso"][current]["activity"] = {};
    }
    // Revisamos que accion es la ejecutada
    if (action == "Llamada") {
      if (bigData["Progreso"][current]["activity"]["Llamada"] == null) {
        bigData["Progreso"][current]["activity"]["Llamada"] = 0;
      }
      bigData["Progreso"][current]["activity"]["Llamada"] =
          bigData["Progreso"][current]["activity"]["Llamada"] + 1;
      // PLAN
    } else if (action == "Plan") {
      if (bigData["Progreso"][current]["activity"]["Plan"] == null) {
        bigData["Progreso"][current]["activity"]["Plan"] = 0;
      }
      bigData["Progreso"][current]["activity"]["Plan"] =
          bigData["Progreso"][current]["activity"]["Plan"] + 1;
      // FOLLOW
    } else if (action == "Seguimiento") {
      if (bigData["Progreso"][current]["activity"]["Seguimiento"] == null) {
        bigData["Progreso"][current]["activity"]["Seguimiento"] = 0;
      }
      bigData["Progreso"][current]["activity"]["Seguimiento"] =
          bigData["Progreso"][current]["activity"]["Seguimiento"] + 1;
      // PLANIFICACION
    } else if (action == "Planificacion") {
      if (bigData["Progreso"][current]["activity"]["Planificacion"] == null) {
        bigData["Progreso"][current]["activity"]["Planificacion"] = 0;
      }
      bigData["Progreso"][current]["activity"]["Planificacion"] =
          bigData["Progreso"][current]["activity"]["Planificacion"] + 1;
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

  updateSesion(FireStore fireStore) {
    if (bigData["Sesion"].isEmpty ||
        DateTime.parse(bigData["Sesion"]).isBefore(now)) {
      bigData["Sesion"] = "${now.year}-${now.month}-${now.day}";
      fireStore.updateDataCloud("UsersData", bigData["User"]["Email"], bigData);
      pref.bigData = json.encode(bigData);
    }
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

  checkContacts(Map contacts) {
    if (contacts.length != bigData["Contactos"]["Prospectos"].length) {
      contacts.forEach((k, v) {
        if (bigData["Contactos"]["Prospectos"][k] == null) {
          bigData["Contactos"]["Prospectos"][k] = v;
        }
      });
    }
  }

  moveContact(
      {required String from, required String to, required String name}) {
    bigData["Contactos"][to][name] = bigData["Contactos"][from][name];
    bigData["Contactos"][from].remove(name);
    notifyListeners();
  }
}

class DataModel {
  List agendaConcept = [
    "Llamada",
    "Plan",
    "Seguimiento",
    "Planificacion",
  ];
}
