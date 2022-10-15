// ignore: file_names
import 'package:flutter/material.dart';
import 'package:master_app/widgets/calendar.dart';
import 'package:master_app/widgets/carousel.dart';

import '../widgets/dynamicBox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: media.height * 0.1,
          child: const AppBarCalendar(),
        ),
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
          child: const DynamicBox(),
        ),
      ],
    );
  }
}
