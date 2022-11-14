import 'package:flutter/material.dart';
import 'package:master_app/Funciones/exeAgenda.dart';
import 'package:provider/provider.dart';

import '../../Provider/bigData.dart';
import '../../Provider/homeProvider.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  late BigData bigdata;
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Revisamos si se cumplio alguna reunion y el tipo de la reunion para ejecutar el popUp
      // final bigdata = Provider.of<BigData>(context, listen: false);
      String action = bigdata.checkAgenda(context);
      if (action.isNotEmpty) {
        bigdata.addAction(context, action, bigdata: bigdata);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final agendaPro = Provider.of<AgendaProvider>(context);
    bigdata = Provider.of<BigData>(context);
    var media = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: (agendaPro.agenda.isNotEmpty) ? agendaPro.agenda.length : 1,
        itemBuilder: (contex, i) {
          if (agendaPro.agenda.isNotEmpty) {
            String hours = agendaPro.agenda.keys.elementAt(i);
            // String hours = _agenda[day].keys.toList()[i];
            bool checked =
                bigdata.bigData["Agenda"][bigdata.today][hours]["checked"];
            return Column(
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  tileColor: Colors.grey[200],
                  leading: Text(
                      "${agendaPro.agenda[hours]["hora"]}:${agendaPro.agenda[hours]["min"]} ${agendaPro.agenda[hours]["meridiano"]}"),
                  title: Text(agendaPro.agenda[hours]["concepto"]),
                  trailing: Icon(
                      (!checked)
                          ? Icons.schedule_rounded
                          : Icons.check_circle_outline_outlined,
                      color:
                          (!checked) ? Colors.yellow[800] : Colors.green[800]),
                  onTap: () {
                    bigdata.load();
                    bigdata.checkAgenda(context);
                  },
                ),
                SizedBox(
                  height: media.height * 0.01,
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("No hay nada agendado aun"),
            );
          }
        });
  }
}
