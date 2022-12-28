import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:master_app/Pages/contactPage.dart';
import 'package:master_app/widgets/PopUp.dart';
import 'package:provider/provider.dart';

import '../../Provider/bigData.dart';
import 'CompromisePage.dart';

class MetasPage extends StatefulWidget {
  @override
  _MetasPageState createState() => _MetasPageState();
}

class _MetasPageState extends State<MetasPage> {
  bool wasSelected = false;
  int _selectedRango = 0;
  List<String> rangoLista = [
    'Asociado',
    'Constructor',
    'Constructor Elite',
    'Diamante',
    'Diamante Elite',
    'Presidencial',
    'Bronce',
    'Bronce Elite',
    'Plata',
    'Plata Elite',
    'Oro',
    'Oro Elite',
    'Platino',
    'Platino Elite'
  ];
  // String rangoSeleccionado = 'Seleccionar Posicion';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bigData = Provider.of<BigData>(context);
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: SizedBox(
                height: media.height * 0.6,
                width: media.width,
                child: Image.asset(
                  fit: BoxFit.fill,
                  'assets/imagenes/niveles_rangos.png',
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 95.0,
              child: Column(
                children: [
                  const Text('Rango Actual',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                      )),
                  (wasSelected == false)
                      ? ElevatedButton(
                          child: const Text('Seleccionar rango',
                              style: TextStyle(fontFamily: 'Ubuntu')),
                          onPressed: () {
                            popUp(context, media, rangos(media));
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return popUpMeta(media);
                            //     });
                            // setState(() {
                            //   // altoBody = 150.0;
                            //   // openListaOption = true;
                            // });
                          },
                        )
                      : ElevatedButton(
                          child: const Text('Siguiente',
                              style: TextStyle(fontFamily: 'Ubuntu')),
                          onPressed: () {
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
                            // popUp(context, media, bigData, rangos());
                            bigData.selectedRango(rangoLista[_selectedRango]);
                            bigData.save();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const CompromisoPage()));
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rangos(Size media) {
    return Material(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text("Aceptar"),
                onPressed: () {
                  setState(() {
                    wasSelected = true;
                  });
                  Navigator.pop(context);
                },
              )
            ],
          ),
          SizedBox(
            height: media.height * 0.3,
            width: media.width,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter xetState) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: rangoLista.length,
                  itemBuilder: (BuildContext context, int i) {
                    return RadioListTile(
                      controlAffinity: ListTileControlAffinity.platform,
                      value: i,
                      title: Text(rangoLista[i]),
                      groupValue: _selectedRango,
                      onChanged: (value) {
                        // print('valor seleccionado: $value');
                        xetState(() => _selectedRango = value!);
                        // print('Rango seleccionado: $_selectedRango');
                      },
                    );
                  });
            }),
          ),
        ],
      ),
    );
  }

  Widget popUpMeta(Size media) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text('Selecciona tu rango actual'),
        contentPadding: const EdgeInsets.fromLTRB(0.0, 18.0, 0.0, 20.0),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter xetState) {
          return Container(
            height: media.height / 2,
            width: media.width - (media.width / 10),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: rangoLista.length,
                itemBuilder: (BuildContext context, int i) {
                  return RadioListTile(
                    controlAffinity: ListTileControlAffinity.platform,
                    value: i,
                    title: Text(rangoLista[i]),
                    groupValue: _selectedRango,
                    onChanged: (value) {
                      print('valor seleccionado: $value');
                      xetState(() => _selectedRango = value!);
                      print('Rango seleccionado: $_selectedRango');
                    },
                  );
                }),
          );
        }),
        actions: [
          TextButton(
              // style: flatButtonStyle,
              child: Text('Ok'),
              onPressed: () {
                setState(() {
                  wasSelected = true;
                });

                Navigator.pop(context);
              })
        ]);
  }
}
