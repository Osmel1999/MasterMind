import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../Funciones/exeContacts.dart';
import '../../Preferencias/sharedPeference.dart';
import '../../Provider/contactProvider.dart';

class Waitting extends StatefulWidget {
  const Waitting({super.key});

  @override
  State<Waitting> createState() => _WaittingState();
}

class _WaittingState extends State<Waitting> {
  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    final pref = PreferenciasUsuario();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: pref.waitting.isNotEmpty ? pref.waitting.length : 1,
      itemBuilder: (context, i) {
        return (pref.waitting.isNotEmpty &&
                pref.waitting
                    .contains(contactProvider.mapaContact.keys.toList()[i]))
            ? (contactProvider.listaSugerida.isEmpty ||
                    contactProvider.listaSugerida
                        .contains(contactProvider.mapaContact.keys.toList()[i]))
                ? Column(
                    children: [
                      ListTile(
                        title:
                            Text(contactProvider.mapaContact.keys.toList()[i]),
                        trailing: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.phone,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  toCall(
                                      "${contactProvider.mapaContact.values.toList()[i]}");
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.whatsapp_rounded,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  // TODO: Nuevo mensaje para los en espera
                                  toWhatsapp(
                                      "${contactProvider.mapaContact.values.toList()[i]}",
                                      "En espera");
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  )
                : Container()
            : const Center(
                child: Text("No hay contactos disponibles"),
              );
      },
    );
  }
}
