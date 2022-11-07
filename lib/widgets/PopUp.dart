import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Provider/bigData.dart';

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

quest(BuildContext context, String action, BigData bigdata) {
  var media = MediaQuery.of(context).size;
  showCupertinoModalPopup(
      context: context,
      builder: (context) {
        Map opt = {
          "Call": ["Confirmo", "No confirmo"],
          "Plan": [],
          "Folow": [],
          "Planification": []
        };
        late int indexSelect;
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
                    // Validams las acciones y ejeutamos la funcion correspondiente
                    if (action == "Call" && opt[action][indexSelect] == 0) {
                      // Hacemos algo
                    } else if (action == "Plan") {
                      // Hacemos otra cosa
                    } else if (action == "Folow") {
                      // Hacemos otra cosa
                    } else if (action == "PlaPlanificationn") {
                      // Hacemos otra cosa
                    }
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
                      print(index);
                      print(opt[action][index]);
                    },
                    children: actOption(action, opt)),
              ),
            ],
          )),
        );
      });
}

List<Widget> actOption(String action, Map opt) {
  List<Widget> list = [];
  opt[action].forEach((e) {
    list.add(Text(e));
  });
  return list;
}

actDo() {}
