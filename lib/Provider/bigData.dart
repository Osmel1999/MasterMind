import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:master_app/widgets/PopUp.dart';
import 'package:provider/provider.dart';

import '../Preferencias/sharedPeference.dart';
import 'Firebase/fire_store.dart';

class BigData with ChangeNotifier {
  final pref = PreferenciasUsuario();

  Map<String, dynamic> bigData = {};

  Map<String, dynamic> d2B = {};

  String respons = "";

  late String today;

  late int? numWeek;

  DateTime now = DateTime.now();

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
                  "Plan": {}
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

  update(Map<String, dynamic> data) {
    bigData = data;
    notifyListeners();
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

  String addAction(BuildContext context, String action, {BigData? bigdata}) {
    String current =
        weekIndicator(DateTime.parse(bigData["Compromiso"]["init"]));
    if (bigData["Progreso"][current] == null) bigData["Progreso"][current] = {};
    addProgress(context, action, current, bigdata);
    save();
    return action;
  }

  addProgress(
      BuildContext context, String action, String current, BigData? _bigdata) {
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
    } else if (action == "Plan") {
      // PLAN
      if (bigData["Progreso"][current]["activity"]["Plan"] == null) {
        bigData["Progreso"][current]["activity"]["Plan"] = 0;
      }
      // Abrimos el popUp.
      List<dynamic> temp = bigData["Contactos"]["Invitado"].keys.toList();
      questTo(
        context,
        action,
        header: "Selecciona quien asistio a: $action",
        listado: temp,
        lastList: "Invitado",
        agendando: "Seguimiento",
        bigdata: _bigdata!,
      );

      bigData["Progreso"][current]["activity"]["Plan"] =
          bigData["Progreso"][current]["activity"]["Plan"] + 1;
    } else if (action == "Seguimiento") {
      // FOLLOW
      if (bigData["Progreso"][current]["activity"]["Seguimiento"] == null) {
        bigData["Progreso"][current]["activity"]["Seguimiento"] = 0;
      }
      // Abrimos el popUp.
      List<String> temp = bigData["Contactos"]["Plan"].keys.toList();
      questTo(
        context,
        action,
        header: "Selecciona quien asistio a: $action",
        listado: temp,
        lastList: "Plan",
        agendando: "Planificacion",
        bigdata: _bigdata!,
      );

      bigData["Progreso"][current]["activity"]["Seguimiento"] =
          bigData["Progreso"][current]["activity"]["Seguimiento"] + 1;
    } else if (action == "Planificacion") {
      // PLANIFICACION
      if (bigData["Progreso"][current]["activity"]["Planificacion"] == null) {
        bigData["Progreso"][current]["activity"]["Planificacion"] = 0;
      }
      // TODO: Crear un sistema especial para esta seccion
      //  // Abrimos el popUp.
      // List<String> temp = bigData["Contactos"]["Plan"].keys.toList();
      // questTo(context, action,
      //     header: "Selecciona quien asistiero a: $action",
      //     listado: temp,
      //     lastList: "Seguimiento",
      //     agendando: "Llamada");

      bigData["Progreso"][current]["activity"]["Planificacion"] =
          bigData["Progreso"][current]["activity"]["Planificacion"] + 1;
    }
  }

  String checkAgenda(BuildContext context) {
    if (checkLitas(bigData["Contactos"])) {
      // bigData = json.decode(pref.bigData);
      DateTime now = DateTime.now();
      Map temp = bigData["Agenda"]["${now.year}-${now.month}-${now.day}"] ?? {};
      if (temp.isNotEmpty) {
        String? lastDate;
        temp.forEach((hora, data) {
          if (now.isAfter(DateTime.parse(data["fecha"]))) {
            lastDate = hora;
          }
        });
        if (lastDate != null && temp[lastDate]["checked"] == false) {
          temp[lastDate]["checked"] = true;
          bigData["Agenda"]["${now.year}-${now.month}-${now.day}"] = temp;
          save();
          return temp[lastDate]["concepto"];
          // addAction(context, temp[lastDate]["concepto"]);

        }
      }
    }
    return "";
  }

  bool checkLitas(Map listas) {
    bool resp = false;
    listas.forEach((k, v) {
      if (k != "Prospectos" && k != "En espera" && k != "Clientes") {
        if (v.isNotEmpty) resp = true;
      }
    });
    return resp;
  }

  String weekIndicator(DateTime init) {
    DateTime now = DateTime.now();
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
    DateTime now = DateTime.now();
    if (bigData["Sesion"].isEmpty ||
        DateTime.parse(bigData["Sesion"])
            .isBefore(DateTime.parse("${now.year}-${now.month}-${now.day}"))) {
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
    // if (isUpdate!) update(json.decode(pref.bigData));
    if (bigData["Contactos"][to] != null) {
      bigData["Contactos"][to][name] = bigData["Contactos"][from][name];
      bigData["Contactos"][from].remove(name);
    } else {
      bigData["Contactos"][to] = {name: bigData["Contactos"][from][name]};
    }
    save();
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
