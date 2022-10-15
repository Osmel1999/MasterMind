import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../Provider/playerProvider.dart';

class AudioList extends StatefulWidget {
  const AudioList({super.key});

  @override
  State<AudioList> createState() => _AudioListState();
}

class _AudioListState extends State<AudioList> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final playerProvider = Provider.of<PlayerProvider>(context);
    return Container(
      child: ListView.builder(
          itemCount: playerProvider.dbAudios.length,
          itemBuilder: (context, i) {
            String title = playerProvider.dbAudios.keys.toList()[i];
            return FadeInLeft(
              duration: const Duration(milliseconds: 900),
              child: Column(
                children: [
                  ListTile(
                    leading: SizedBox(
                      height: media.height * 0.08,
                      width: media.height * 0.08,
                      child: CachedNetworkImage(
                        imageUrl: playerProvider.dbAudios[title]["Imagen"],
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
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
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          playerProvider.dbAudios[title]["Autor"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    trailing: Icon(
                      Icons.multitrack_audio_rounded,
                      color: (playerProvider
                                  .assetsAudioPlayer.getCurrentAudioTitle ==
                              title)
                          ? Colors.green
                          : null,
                    ),
                    onTap: () {
                      playerProvider.changeAudio(title);
                    },
                  ),
                  const Divider(
                    thickness: 2,
                  )
                ],
              ),
            );
          }),
    );
  }
}
