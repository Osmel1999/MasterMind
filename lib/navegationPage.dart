import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:master_app/Pages/mediaPage.dart';
import 'package:master_app/Provider/homeProvider.dart';
import 'package:provider/provider.dart';

import 'Pages/contactPage.dart';
import 'Pages/homePage.dart';
import 'Pages/statsPage.dart';
import 'Provider/navProvider.dart';
import 'package:master_app/local_notification/local_notification.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  Map<String, Widget> body = const {
    "Inicio": HomePage(),
    "Contactos": ContactsPage(),
    "IA": StatsPage(),
    "Multi-Media": MediaPage(),
  };

  // int navIndex = 0;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final navProv = Provider.of<NavigationProvider>(context);
    final agendaProvider = Provider.of<AgendaProvider>(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: media.height * 0.012, horizontal: media.height * 0.005),
        child: SingleChildScrollView(
          child: Column(children: [
            // TODO: APP BAR
            Container(
              padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
              // color: Colors.blueAccent,
              width: media.width,
              height: media.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        // ignore: sort_child_properties_last
                        child: Icon(
                          Icons.add_alarm_rounded,
                          color: (navProv.indexNav == 0)
                              ? Colors.black
                              : Colors.white,
                        ),
                        onTap: (navProv.indexNav == 0)
                            ? () async {
                                agendaProvider.addEvent(context, media);
                              }
                            : null,
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      body.keys.toList()[navProv.indexNav],
                      style: const TextStyle(
                          // color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.person),
                  ),
                ],
              ),
            ),
            // TODO: BODY
            body[body.keys.toList()[navProv.indexNav]]!,
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        width: media.width,
        height: media.height * 0.12,
        child: SizedBox(
          height: media.height * 0.12,
          child: CurvedNavigationBar(
            color: Colors.blueAccent,
            backgroundColor: Colors.transparent,
            items: const [
              Icon(Icons.list_rounded, size: 30, color: Colors.white),
              Icon(Icons.perm_contact_cal_outlined,
                  size: 30, color: Colors.white),
              Icon(Icons.bubble_chart, size: 30, color: Colors.white),
              Icon(Icons.school_rounded, size: 30, color: Colors.white),
            ],
            onTap: (index) {
              //Handle button tap
              navProv.changeScreen(index);
            },
          ),
        ),
      ),
    );
  }
}
