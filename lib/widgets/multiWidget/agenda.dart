import 'package:flutter/material.dart';
import 'package:master_app/Funciones/exeAgenda.dart';
import 'package:provider/provider.dart';

import '../../Provider/homeProvider.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  @override
  Widget build(BuildContext context) {
    final agendaPro = Provider.of<AgendaProvider>(context);
    var media = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: (agendaPro.agenda.length != 0) ? agendaPro.agenda.length : 1,
        itemBuilder: (contex, i) {
          if (agendaPro.agenda.isNotEmpty) {
            String hours = agendaPro.agenda.keys.elementAt(i);
            // String hours = _agenda[day].keys.toList()[i];
            return Column(
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  tileColor: Colors.grey[200],
                  leading: Text(
                      "${agendaPro.agenda[hours]["hora"]}:${agendaPro.agenda[hours]["min"]} ${agendaPro.agenda[hours]["dateTime"]}"),
                  title: Text(agendaPro.agenda[hours]["concepto"]),
                  trailing: Icon(
                    Icons.schedule_rounded,
                    color: Colors.green[800],
                  ),
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
