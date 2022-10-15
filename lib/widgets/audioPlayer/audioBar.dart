import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:master_app/Provider/playerProvider.dart';
import 'package:provider/provider.dart';

class AudioBar extends StatefulWidget {
  const AudioBar({super.key});

  @override
  State<AudioBar> createState() => _AudioBarState();
}

class _AudioBarState extends State<AudioBar> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final playerProvider = Provider.of<PlayerProvider>(context);
    return Container(
      height: media.height * 0.09,
      width: media.width * 0.98,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.grey[200],
      ),
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
              height: media.height * 0.08,
              width: media.height * 0.08,
              child: CachedNetworkImage(
                imageUrl:
                    playerProvider.assetsAudioPlayer.getCurrentAudioImage!.path,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            title: SizedBox(
                width: media.width * 0.12,
                height: media.height * 0.08,
                child: (playerProvider.audioPath.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            playerProvider
                                .assetsAudioPlayer.getCurrentAudioTitle,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            playerProvider
                                .assetsAudioPlayer.getCurrentAudioArtist,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.green,
                        ),
                      )),
            trailing: SizedBox(
              height: media.height * 0.08,
              width: media.width * 0.15,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    iconSize: 40,
                    icon: Icon((playerProvider.isPLaying == true)
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded),
                    color: (playerProvider.isPLaying == true)
                        ? Colors.green.withOpacity(0.6)
                        : Colors.green,
                    onPressed: () {
                      playerProvider.playOrPause();
                    },
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            child: playerProvider.assetsAudioPlayer.builderRealtimePlayingInfos(
                builder: (context, infos) {
              return LinearProgressIndicator(
                  minHeight: 5,
                  color: Colors.green,
                  backgroundColor: Colors.green.withOpacity(0.4),
                  value: infos.duration.inMilliseconds == 0
                      ? 0
                      : infos.currentPosition.inMilliseconds /
                          infos.duration.inMilliseconds);
            }),
          ),
        ],
      ),
    );
  }
}
