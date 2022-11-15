// ignore: file_names
import 'package:flutter/material.dart';
import 'package:master_app/widgets/calendar.dart';
import 'package:master_app/widgets/carousel.dart';
import 'package:provider/provider.dart';

import '../Provider/Firebase/fire_store.dart';
import '../Provider/bigData.dart';
import '../widgets/dynamicBox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BigData bigdata;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bigdata.newSesion(FireStore());
    });
  }

  @override
  Widget build(BuildContext context) {
    bigdata = Provider.of<BigData>(context);
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
            item: bigdata.bigData["Sueños"].values.toList(),
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
