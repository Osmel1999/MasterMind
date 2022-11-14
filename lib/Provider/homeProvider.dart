import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_app/Preferencias/sharedPeference.dart';
import '../local_notification/local_notification.dart';
import '../widgets/PopUp.dart';
import 'bigData.dart';

class DynamicBoxProvider with ChangeNotifier {
  int boxPosition = 0;

  changeIndex(int i) {
    boxPosition = i;
    notifyListeners();
  }
}

class AgendaProvider with ChangeNotifier {
  final notificationService = NotificationService();
  final pref = PreferenciasUsuario();
  DateTime now = DateTime.now();
  // late DateTime dateSelected;
  String dataDay = "";
  Map<String, dynamic> dbAgenda = {};
  Map<dynamic, dynamic> agenda = {};
  DateTime? eventDateTime;
  String queryEvent = "";
  // DateTime? eventTime;

  AgendaProvider() {
    _initConfig();
  }

  _initConfig() {
    DateTime dateSelected = DateTime(now.year, now.month, now.day);
    // dateSelected = DateTime.parse("2022-10-11");
    dataDay = "${dateSelected.year}-${dateSelected.month}-${dateSelected.day}";

    dbAgenda =
        pref.bigData.isNotEmpty ? json.decode(pref.bigData)["Agenda"] : {};
    agenda = dbAgenda[dataDay] ?? {};
  }

  daySelected(DateTime dateSelected) {
    dataDay =
        ("${dateSelected.year}-${dateSelected.month}-${dateSelected.day}");
    agenda = dbAgenda[dataDay] ?? {};
    notifyListeners();
  }

  void addEvent(BuildContext context, Size media, BigData bigdata,
      {String? concepto}) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Material(
            child: Container(
                height: media.height * 0.5,
                width: media.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              (concepto != null)
                                  ? "Agendar $concepto"
                                  : "Agendar evento",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          TextButton(
                              onPressed: () {
                                if (concepto != null) {
                                  addDB(eventDateTime!, concepto,
                                      bigdata: bigdata);
                                  // dbAgenda;
                                  notificationService.scheduleNotification(
                                      'Agenda', concepto, eventDateTime!, 1);
                                  print(bigdata.bigData["Agenda"]);
                                  Navigator.of(context).pop();
                                } else {
                                  Navigator.pop(context);
                                  addConcept(
                                      context: context,
                                      lista: [],
                                      bigData: bigdata);
                                }
                              },
                              child: const Text(
                                "Listo",
                                style: TextStyle(color: Colors.blueAccent),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: media.height * 0.3,
                      width: media.width * 0.9,
                      color: Colors.white,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        onDateTimeChanged: (date) {
                          eventDateTime = date;
                        },
                        initialDateTime: DateTime.now(),
                        minimumYear: DateTime.now().year,
                        maximumYear: DateTime.now().year + 1,
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  addConcept(
      {required BuildContext context,
      required List<Widget> lista,
      required BigData bigData}) {
    var media = MediaQuery.of(context).size;
    final dataModel = DataModel();
    String concept = dataModel.agendaConcept[0];
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            height: media.height * 0.4,
            width: media.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: media.width * 0.01),
                  child: TextButton(
                    child: const Text("Listo"),
                    onPressed: () {
                      addDB(eventDateTime!, concept, bigdata: bigData);
                      dbAgenda;
                      Navigator.of(context).pop();
                      notificationService.scheduleNotification(
                          'Agenda', concept, eventDateTime!, 1);
                    },
                  ),
                ),
                SizedBox(
                  // width: media.width * 0.8,
                  height: media.height * 0.3,
                  child: CupertinoPicker(
                      itemExtent: 50,
                      onSelectedItemChanged: (index) {
                        concept = dataModel.agendaConcept[index];
                      },
                      children: option(datos: dataModel.agendaConcept)),
                ),
              ],
            ),
          );
        });
  }

  String minToString(DateTime time) {
    String tiempo = "";
    tiempo = (time.minute < 10) ? "0${time.minute}" : "${time.minute}";
    return tiempo;
  }

  addDB(DateTime date, String query, {required BigData bigdata}) {
    // agregamos la nueva data en (String)
    Map temp = {
      ...dbAgenda["${date.year}-${date.month}-${date.day}"] ?? {},
      ("${date.hour}${minToString(date)}"): {
        "meridiano": "AM",
        "hora": "${date.hour}",
        "min": minToString(date),
        "concepto": query,
        "fecha": date.toString(),
        "checked": false,
      }
    };
    // Convetimos los keys de la data del dia a (int)
    List kTemp = [];
    temp.keys.toList().forEach((i) {
      kTemp.add(int.parse(i));
    });
    // Organizamos de mayor a menos los keys del los dias
    kTemp.sort();
    // regresamos los keys y value ya organizados a dbAgenda
    dbAgenda["${date.year}-${date.month}-${date.day}"] = {};
    for (var e in kTemp) {
      dbAgenda["${date.year}-${date.month}-${date.day}"] = {
        ...dbAgenda["${date.year}-${date.month}-${date.day}"] ?? {},
        "$e": temp['$e']
      };
    }
    agenda = dbAgenda[dataDay] ?? {};
    bigdata.update({...bigdata.bigData, "Agenda": dbAgenda});
    bigdata.save();
    notifyListeners();
  }

  void addCompromiso(BuildContext context, Size media, BigData bigdata) {
    TextEditingController eNoteController = TextEditingController();
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Material(
            child: Container(
                height: media.height * 0.5,
                width: media.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Agendar evento",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          TextButton(
                              onPressed: () {
                                addDB(eventDateTime!, eNoteController.text,
                                    bigdata: bigdata);

                                Navigator.of(context).pop();
                                notificationService.scheduleNotification(
                                    'Agenda',
                                    eNoteController.text,
                                    eventDateTime!,
                                    1);
                              },
                              child: const Text(
                                "Listo",
                                style: TextStyle(color: Colors.blueAccent),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: media.height * 0.3,
                      width: media.width * 0.9,
                      color: Colors.white,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        onDateTimeChanged: (date) {
                          eventDateTime = date;
                        },
                        initialDateTime: DateTime.now(),
                        minimumYear: DateTime.now().year,
                        maximumYear: DateTime.now().year + 1,
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
