import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  State<Teams> createState() => _TeamsState();
}

Map<String, dynamic> partners = {
  "odfarakm@gmail.com": {"name": "Osmel Farak", "Progreso": 0.6, "raiz": "2"},
};

class _TeamsState extends State<Teams> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: partners.length,
        itemBuilder: (context, i) {
          String key = partners.keys.elementAt(i);
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
                      leading: Icon(
                        Icons.account_circle_rounded,
                        color: Colors.green[800],
                      ),
                      title: Text(partners[key]["name"]),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${(partners[key]["raiz"])}"),
                          const Text("Linea")
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.blue.withOpacity(0.4),
                        value: partners[key]["Progreso"],
                      ),
                    ),
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
