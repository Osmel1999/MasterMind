import 'package:flutter/material.dart';
import 'package:master_app/Pages/SignIn/MentorSelector.dart';
import 'package:master_app/Provider/homeProvider.dart';
import 'package:provider/provider.dart';

import '../../Provider/bigData.dart';
import '../../Provider/navProvider.dart';

class CompromisoPage extends StatefulWidget {
  const CompromisoPage({super.key});

  @override
  State<CompromisoPage> createState() => _CompromisoPageState();
}

class _CompromisoPageState extends State<CompromisoPage> {
  @override
  Widget build(BuildContext context) {
    final bigdata = Provider.of<BigData>(context);
    final agenda = Provider.of<AgendaProvider>(context);
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
          height: media.height,
          width: media.width,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 5.0),
                child: SingleChildScrollView(
                  child: Image.asset(
                    'assets/imagenes/Compromiso_SEN.png',
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                // right: 95.0,
                child: SizedBox(
                  height: media.height * 0.1,
                  width: media.width,
                  child: Column(
                    children: [
                      // const Text('Acepto el compromiso',
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //       fontSize: 25.0,
                      //       fontFamily: 'Ubuntu',
                      //       fontWeight: FontWeight.bold,
                      //     )),
                      SizedBox(
                        width: media.width * 0.8,
                        child: ElevatedButton(
                          child: const Text('Aceptar',
                              style: TextStyle(fontFamily: 'Ubuntu')),
                          onPressed: () {
                            agenda.addCompromiso(context, media, bigdata);
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return Container(
                            //       margin: const EdgeInsets.symmetric(
                            //           vertical: 280.0, horizontal: 152.5),
                            //       child: CircularProgressIndicator(
                            //         valueColor: AlwaysStoppedAnimation<Color>(
                            //             Colors.amber[900]!),
                            //       ),
                            //     );
                            //   },
                            // );
                            // bigData.selectedRango(rangoLista[_selectedRango]);
                            bigdata.bigData["Compromiso"] = {
                              "aceptado": true,
                              "hora": "10:30",
                              "init": bigdata.today,
                            };

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MentorSelector()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
