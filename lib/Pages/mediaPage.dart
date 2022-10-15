import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/playerProvider.dart';
import '../widgets/audioPlayer/Trending.dart';
import '../widgets/audioPlayer/audioBar.dart';
import '../widgets/audioPlayer/audioList.dart';
import '../widgets/audioSelector.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    var media = MediaQuery.of(context).size;

    final myAudio = (playerProvider.audioPath.isNotEmpty)
        ? playerProvider.find(playerProvider.audios, playerProvider.audioPath)
        : null;
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              width: media.width * 0.95,
              height: media.height * 0.04,
              child: Row(
                children: const [
                  Text(
                    "Tendencias",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: media.width * 0.95,
              height: media.height * 0.21,
              child: Trending(),
            ),
            SizedBox(
              width: media.width * 0.95,
              height: media.height * 0.5,
              child: const AudioList(),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: media.width * 0.02,
          child: SizedBox(
            height: media.height * 0.1,
            width: media.width * 0.95,
            child: playerProvider.audioPath.isNotEmpty
                ? FadeInUp(
                    duration: const Duration(milliseconds: 900),
                    child: const AudioBar(),
                  )
                : Container(),
          ),
        ),
      ],
    );
  }
}
