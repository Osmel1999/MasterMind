import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:master_app/Preferencias/sharedPeference.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Funciones/exeContacts.dart';
import '../../Provider/contactProvider.dart';

class Costumers extends StatefulWidget {
  const Costumers({super.key});

  @override
  State<Costumers> createState() => _CostumersState();
}

class _CostumersState extends State<Costumers> {
  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    final pref = PreferenciasUsuario();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: pref.constumerList.isNotEmpty ? pref.constumerList.length : 1,
      itemBuilder: (context, i) {
        return (pref.constumerList.isNotEmpty &&
                pref.constumerList
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
                                  // TODO: Nuevo mensaje para los consumidores
                                  toWhatsapp(
                                      "${contactProvider.mapaContact.values.toList()[i]}",
                                      "Consumidor");
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
