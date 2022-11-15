import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../Provider/bigData.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

// Map<String, dynamic> metrics = {
//   "Llamadas": {"Meta": 20, "Hechas": 3},
//   "Presentacion": {"Meta": 2, "Hechas": 0},
//   "Seguimiento": {"Meta": 4, "Hechas": 1},
//   "Planificacion": {"Meta": 1, "Hechas": 0}
// };

Map<String, dynamic> metas = {
  "Llamadas": 20,
  "Presentacion": 2,
  "Seguimiento": 4,
  "Planificacion": 1
};

Map<String, dynamic> iconos = {
  "Llamadas": {
    "icono": Icon(
      Icons.phone,
      color: Colors.green[800],
    ),
    "colorLinea": Colors.green,
    "colorLineaB": Colors.green.withOpacity(0.4),
  },
  "Presentacion": {
    "icono": Icon(
      Icons.ondemand_video_rounded,
      color: Colors.pink[700],
    ),
    "colorLinea": Colors.pink,
    "colorLineaB": Colors.pink.withOpacity(0.4),
  },
  "Seguimiento": {
    "icono": Icon(
      Icons.question_answer_rounded,
      color: Colors.amber[600],
    ),
    "colorLinea": Colors.amber,
    "colorLineaB": Colors.amber.withOpacity(0.4),
  },
  "Planificacion": {
    "icono": Icon(
      Icons.design_services_rounded,
      color: Colors.blue[700],
    ),
    "colorLinea": Colors.blue,
    "colorLineaB": Colors.blue.withOpacity(0.4),
  }
};

class _ToDoState extends State<ToDo> {
  late BigData bigdata;

  @override
  Widget build(BuildContext context) {
    bigdata = Provider.of<BigData>(context);
    var media = MediaQuery.of(context).size;
    Map<String, dynamic> metricas = bigdata.getProgress();
    return ListView.builder(
        itemCount: metas.length,
        itemBuilder: (context, i) {
          String key = metas.keys.elementAt(i);
          int hechas = metricas[key] ?? 0;
          return Column(
            children: [
              Container(
                height: media.height * 0.09,
                width: media.width * 0.95,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.grey[200],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: iconos[key]["icono"],
                      title: Text(key),
                      trailing: Text(
                          "${hechas.toString()} / ${metas[key].toString()}"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      child: LinearProgressIndicator(
                        backgroundColor: iconos[key]["colorLineaB"],
                        valueColor: AlwaysStoppedAnimation<Color>(
                            iconos[key]["colorLinea"]),
                        value: (hechas / metas[key]),
                        // minHeight: 4,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: media.height * 0.01,
              ),
            ],
          );
        });
  }
}
