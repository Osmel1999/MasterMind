import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

questTo(BuildContext context, String action, BigData bigdata) {
  var media = MediaQuery.of(context).size;

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
          child: Center(
              child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: media.width * 0.01),
                child: TextButton(
                    child: const Text("Aceptar"),
                    onPressed: () {
                      // Ejecutar una accion dependiendo de la opcion escogida
                    }),
              ),
              SizedBox(
                width: media.width * 0.8,
                height: media.height * 0.3,
                child: CupertinoPicker(
                    itemExtent: 50,
                    onSelectedItemChanged: (int index) {
                      indexSelect = index;
                    },
                    children: option(
                        key: "",
                        data: bigdata.bigData["Agenda"][bigdata.today])),
              ),
            ],
          )),
        );
      });
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
