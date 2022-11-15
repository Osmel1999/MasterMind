import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:master_app/Pages/PartnerViewer/dynamix.dart';
import 'package:master_app/Pages/PartnerViewer/peerDo.dart';
import 'package:master_app/Pages/PartnerViewer/teamx.dart';

import '../../widgets/carousel.dart';
import '../../widgets/multiWidget/toDo.dart';

class PartnerPage extends StatefulWidget {
  Map<String, dynamic> data;
  PartnerPage({super.key, required this.data});

  @override
  State<PartnerPage> createState() => _PartnerPageState();
}

class _PartnerPageState extends State<PartnerPage> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: Center(child: Text(widget.data["User"]["Name"])),
        ),
        body: Column(
          children: [
            // SizedBox(
            //   height: media.height * 0.1,
            //   child: const AppBarCalendar(),
            // ),
            // TODO: Sueńos
            SizedBox(
              height: media.height * 0.25,
              child: Carousel(
                height: media.height * 0.25,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
            ),
            // TODO: MultiData
            SizedBox(
              height: media.height * 0.4,
              child: Dynamix(
                boxes: {
                  "Progreso": PeerDo(progress: widget.data["Progreso"]),
                  "Equipo": Teamx(peers: widget.data["Equipo"]),
                },
              ),
            ),
          ],
        ));
  }
}
