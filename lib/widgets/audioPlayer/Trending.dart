import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:master_app/widgets/carousel.dart';
import 'package:provider/provider.dart';

import '../../Provider/playerProvider.dart';

class Trending extends StatefulWidget {
  const Trending({super.key});

  @override
  State<Trending> createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    var media = MediaQuery.of(context).size;
    return Carousel(
      height: media.height * 0.21,
      aspectRatio: 8 / 8,
      viewportFraction: 0.6,
      // item: playerProvider.trending,
    );
  }
}
