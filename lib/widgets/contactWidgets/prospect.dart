import 'package:flutter/material.dart';
import 'package:master_app/Provider/bigData.dart';
import 'package:master_app/widgets/PopUp.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:master_app/widgets/buscadorTXT.dart';
import 'package:provider/provider.dart';

import '../../Funciones/exeContacts.dart';
import '../../Provider/contactProvider.dart';

class Prospect extends StatefulWidget {
  const Prospect({super.key});

  @override
  State<Prospect> createState() => _ProspectState();
}

class _ProspectState extends State<Prospect> {
  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    final bigdata = Provider.of<BigData>(context);
    var media = MediaQuery.of(context).size;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: contactProvider.mapaContact.isNotEmpty
          ? contactProvider.mapaContact.length
          : 1,
      itemBuilder: (context, i) {
        return (contactProvider.mapaContact.isNotEmpty)
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
                                  // cuantificar la llamada.
                                  bigdata.addAction("Call", 1);
                                  quest(context, "Call", bigdata);
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
                                  // Whatsapp
                                  toWhatsapp(
                                      "${contactProvider.mapaContact.values.toList()[i]}",
                                      "Hola! \n Me gustaría hablarte de algo importante. Tienes un minuto?");
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
