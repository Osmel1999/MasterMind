import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class PlayingControls extends StatelessWidget {
  final bool isPlaying;
  final LoopMode? loopMode;
  final bool isPlaylist;
  final Function()? onPrevious;
  final Function() onPlay;
  final Function()? onNext;
  final Function()? toggleLoop;
  final Function()? onStop;

  const PlayingControls({
    super.key,
    required this.isPlaying,
    this.isPlaylist = false,
    this.loopMode,
    this.toggleLoop,
    this.onPrevious,
    required this.onPlay,
    this.onNext,
    this.onStop,
  });

  Widget _loopIcon(BuildContext context) {
    const iconSize = 34.0;
    if (loopMode == LoopMode.none) {
      return const Icon(
        Icons.loop,
        size: iconSize,
        color: Colors.grey,
      );
    } else if (loopMode == LoopMode.playlist) {
      return const Icon(
        Icons.loop,
        size: iconSize,
        color: Colors.black,
      );
    } else {
      //single
      return Stack(
        alignment: Alignment.center,
        children: const [
          Icon(
            Icons.loop,
            size: iconSize,
            color: Colors.black,
          ),
          Center(
            child: Text(
              '1',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () {
            if (toggleLoop != null) toggleLoop!();
          },
          child: _loopIcon(context),
        ),
        const SizedBox(
          width: 4,
        ),
        ElevatedButton(
          onPressed: isPlaylist ? onPrevious : null,
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        const SizedBox(
          width: 12,
        ),
        ElevatedButton(
          onPressed: onPlay,
          child: Icon(
            isPlaying
                ? Icons.pause_circle_filled_rounded
                : Icons.play_circle_fill_rounded,
            size: 32,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        ElevatedButton(
          onPressed: isPlaylist ? onNext : null,
          child: const Icon(Icons.arrow_forward_ios_rounded),
        ),
        const SizedBox(
          width: 20,
        ),
        if (onStop != null)
          ElevatedButton(
            onPressed: onStop,
            child: const Icon(
              Icons.stop_circle,
              size: 32,
            ),
          ),
      ],
    );
  }
}
