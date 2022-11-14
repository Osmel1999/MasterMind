import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_app/Provider/homeProvider.dart';
import 'package:provider/provider.dart';
import '../Provider/bigData.dart';

Map opt = {
  "Llamada": ["Confirmo", "No confirmo"],
  "Plan": ["Asistio", "No asistio"],
  "Seguimiento": ["Oportunidad", "Consumidor", "No asistio"],
  "Planification": ["Asistio", "No asistio"]
};
int indexSelect = 0;

void popUp(BuildContext context, Size media, Widget widget) {
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
          child: Center(child: widget),
        );
      });
}

quest(
    BuildContext context, String action, String nameContact, BigData bigdata) {
  var media = MediaQuery.of(context).size;
  showCupertinoModalPopup(
      context: context,
      builder: (context) {
        int indexSelect = 0;
        return Container(
          height: media.height * 0.4,
          width: media.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: media.width * 0.01),
                child: TextButton(
                  child: const Text("Aceptar"),
                  onPressed: () {
                    actDo(context, action, opt[action][indexSelect],
                        nameContact, bigdata);
                    bigdata.save();
                  },
                ),
              ),
              SizedBox(
                width: media.width * 0.8,
                height: media.height * 0.3,
                child: CupertinoPicker(
                    itemExtent: 50,
                    onSelectedItemChanged: (int index) {
                      indexSelect = index;
                      bigdata.respons = opt[action][index];
                    },
                    children: option(key: action, data: opt)),
              ),
            ],
          )),
        );
      });
}

List<Widget> option({String? key, Map? data, List? datos}) {
  List<Widget> list = [];
  if (data != null) {
    opt[key].forEach((e) {
      list.add(Text(e));
    });
  } else if (datos != null) {
    for (var e in datos) {
      list.add(Text(e));
    }
  }

  return list;
}

questTo(BuildContext context, String action,
    {required String lastList,
    required String header,
    required BigData bigdata,
    List<dynamic>? listado,
    String? agendando}) {
  // final bigdata = Provider.of<BigData>(context, listen: false);
  var media = MediaQuery.of(context).size;

  showCupertinoModalPopup(
      context: context,
      builder: (context) {
        Map added = {};
        return Material(
          child: Container(
            height: media.height * 0.8,
            width: media.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: media.width * 0.02),
                      child: Text(
                        header,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                        child: const Text("Aceptar"),
                        onPressed: () {
                          // Ejecutar una accion dependiendo de la opcion escogida
                          // bigdata.update(json.decode(bigdata.pref.bigData));
                          added.forEach((k, v) {
                            bigdata.moveContact(
                                from: lastList, to: action, name: k);
                          });
                          Navigator.pop(context);
                        })
                  ],
                ),
                StatefulBuilder(builder: (context, StateSetter setState) {
                  return SizedBox(
                    height: media.height * 0.7,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listado!.length,
                        itemBuilder: (context, i) {
                          return Column(
                            children: [
                              SizedBox(
                                height: media.height * 0.1,
                                width: media.width,
                                child: ListTile(
                                  leading: (added.containsKey(listado[i])
                                      ? const Icon(
                                          Icons.circle,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.circle_outlined,
                                          color: Colors.black,
                                        )),
                                  title: Text(
                                    listado[i],
                                    style: TextStyle(
                                        color: (added.containsKey(listado[i])
                                            ? Colors.blue
                                            : Colors.black)),
                                  ),
                                  onTap: () {
                                    if (!added.containsKey(listado[i])) {
                                      added[listado[i]] = {};
                                      nextPop(
                                          context: context,
                                          agendando: agendando,
                                          bigdata: bigdata);
                                    } else {
                                      added.remove(listado[i]);
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),
                              const Divider()
                            ],
                          );
                        }),
                  );
                })
              ],
            )),
          ),
        );
      });
}

nextPop(
    {required BuildContext context,
    String? agendando,
    required BigData bigdata}) {
  final agnedaPro = Provider.of<AgendaProvider>(context, listen: false);
  var media = MediaQuery.of(context).size;
  agnedaPro.addEvent(context, media, bigdata, concepto: agendando);
}

Widget pickerRuleta(Size media, List<String> listado) {
  return SizedBox(
    width: media.width * 0.8,
    height: media.height * 0.3,
    child: CupertinoPicker(
        itemExtent: 50,
        onSelectedItemChanged: (int index) {
          indexSelect = index;
        },
        children: option(datos: listado)),
  );
}

actDo(BuildContext context, String action, String result, String nameContact,
    BigData bigdata) {
  // Validams las acciones y ejeutamos la funcion correspondiente
  if (action == "Llamada" && result == "Confirmo") {
    // Movemos al contacto a la lista de invitados.
    bigdata.moveContact(from: "Prospectos", to: "Invitado", name: nameContact);
  } else if (action == "Plan") {
    // Hacemos otra cosa
    bigdata.respons = "";
  } else if (action == "Seguimiento") {
    // Hacemos otra cosa
    bigdata.respons = "";
  } else if (action == "Planificationn") {
    // Hacemos otra cosa
    bigdata.respons = "";
  } else {
    bigdata.respons = "";
  }
  Navigator.pop(context);
}
