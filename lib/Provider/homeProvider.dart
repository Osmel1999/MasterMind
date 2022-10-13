import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_app/Preferencias/sharedPeference.dart';
import '../local_notification/local_notification.dart';

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
  Map<String, dynamic> agenda = {};
  DateTime? eventDateTime;
  // DateTime? eventTime;

  AgendaProvider() {
    _initConfig();
  }

  _initConfig() {
    DateTime dateSelected = DateTime(now.year, now.month, now.day);
    // dateSelected = DateTime.parse("2022-10-11");
    dataDay = "${dateSelected.year}-${dateSelected.month}-${dateSelected.day}";

    dbAgenda = pref.agendPref.isNotEmpty ? json.decode(pref.agendPref) : {};
    agenda = dbAgenda[dataDay] ?? {};
  }

  daySelected(DateTime dateSelected) {
    dataDay =
        ("${dateSelected.year}-${dateSelected.month}-${dateSelected.day}");
    agenda = dbAgenda[dataDay] ?? {};
    notifyListeners();
  }

  void addEvent(BuildContext context, Size media) {
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
                              onPressed: (eventDateTime != null &&
                                      eNoteController.text.isNotEmpty)
                                  ? () {
                                      addDB(eventDateTime!,
                                          eNoteController.text, null);
                                      Navigator.of(context).pop();
                                      notificationService.scheduleNotification(
                                          'Agenda',
                                          eNoteController.text,
                                          eventDateTime!,
                                          1);
                                    }
                                  : null,
                              child: const Text(
                                "Listo",
                                style: TextStyle(color: Colors.blueAccent),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: media.height * 0.05,
                      width: media.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: TextFormField(
                        cursorWidth: 2,
                        cursorHeight: 20,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          fillColor: Colors.white54,
                          // labelText: 'Buscar contacto',
                          labelStyle: TextStyle(fontFamily: 'Ubuntu'),
                          prefixIcon: Icon(
                            Icons.event_note_rounded,
                            color: Colors.blueAccent,
                            size: 20.0,
                          ),
                        ),
                        controller: eNoteController,
                      ),
                    ),
                    Container(
                      height: media.height * 0.3,
                      width: media.width * 0.9,
                      color: Colors.white,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        onDateTimeChanged: (date) {
                          print(date);
                          eventDateTime = date;
                        },
                        initialDateTime: DateTime.now(),
                        minimumYear: DateTime.now().year,
                        maximumYear: 2021,
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  addDB(DateTime date, String query, String? action) {
    dbAgenda["${date.year}-${date.month}-${date.day}"] = {
      ...dbAgenda["${date.year}-${date.month}-${date.day}"] ?? "",
      int.parse("${date.hour}${date.minute}"): {
        "dateTime": "AM",
        "hora": "${date.hour}",
        "min": "${date.minute}",
        "concepto": query,
      }
    };
    notifyListeners();
    pref.agendPref = json.encode(dbAgenda);
  }
}
