import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/playerProvider.dart';
import '../widgets/audioPlayer/audioBar.dart';
import '../widgets/audioPlayer/playControls.dart';
import '../widgets/audioPlayer/positionSeek.dart';
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
    return SafeArea(
        child: Column(
      children: [
        SizedBox(
          width: media.width * 0.95,
          height: media.height * 0.61,
        ),
        SizedBox(
          height: media.height * 0.1,
          width: media.width * 0.95,
          child: AudioBar(),
        ),
      ],
    ));
  }
}

// class MyWidget extends StatefulWidget {
//   const MyWidget({super.key});

//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 48.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               const SizedBox(
//                 height: 20,
//               ),
//               Stack(
//                 fit: StackFit.passthrough,
//                 children: <Widget>[
//                   (myAudio != null)
//                       ? Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             child: myAudio.metas.image?.path == null
//                                 ? const SizedBox()
//                                 : myAudio.metas.image?.type == ImageType.network
//                                     ? Image.network(
//                                         myAudio.metas.image!.path,
//                                         height: 150,
//                                         width: 150,
//                                         fit: BoxFit.contain,
//                                       )
//                                     : Image.asset(
//                                         myAudio.metas.image!.path,
//                                         height: 150,
//                                         width: 150,
//                                         fit: BoxFit.contain,
//                                       ),
//                           ),
//                         )
//                       : const Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         playerProvider.assetsAudioPlayer.playOrPause();
//                         // AssetsAudioPlayer.playAndForget(
//                         //     Audio('assets/audios/horn.mp3'));
//                       },
//                       child: Icon(
//                         Icons.add_alert,
//                         color: Colors.grey[800],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               playerProvider.assetsAudioPlayer.builderCurrent(
//                   builder: (context, Playing? playing) {
//                 return Column(
//                   children: <Widget>[
//                     playerProvider.assetsAudioPlayer.builderLoopMode(
//                       builder: (context, loopMode) {
//                         return PlayerBuilder.isPlaying(
//                             player: playerProvider.assetsAudioPlayer,
//                             builder: (context, isPlaying) {
//                               return PlayingControls(
//                                 loopMode: loopMode,
//                                 isPlaying: isPlaying,
//                                 isPlaylist: true,
//                                 onStop: () {
//                                   playerProvider.assetsAudioPlayer.stop();
//                                 },
//                                 toggleLoop: () {
//                                   playerProvider.assetsAudioPlayer.toggleLoop();
//                                 },
//                                 onPlay: () {
//                                   playerProvider.assetsAudioPlayer
//                                       .playOrPause();
//                                 },
//                                 onNext: () {
//                                   //_assetsAudioPlayer.forward(Duration(seconds: 10));
//                                   playerProvider.assetsAudioPlayer.next(
//                                       keepLoopMode:
//                                           true /*keepLoopMode: false*/);
//                                 },
//                                 onPrevious: () {
//                                   playerProvider.assetsAudioPlayer.previous(
//                                       /*keepLoopMode: false*/);
//                                 },
//                               );
//                             });
//                       },
//                     ),
//                     playerProvider.assetsAudioPlayer
//                         .builderRealtimePlayingInfos(
//                             builder: (context, RealtimePlayingInfos? infos) {
//                       if (infos == null) {
//                         return const SizedBox();
//                       }
//                       //print('infos: $infos');
//                       return Column(
//                         children: [
//                           PositionSeekWidget(
//                             currentPosition: infos.currentPosition,
//                             duration: infos.duration,
//                             seekTo: (to) {
//                               playerProvider.assetsAudioPlayer.seek(to);
//                             },
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () {
//                                   playerProvider.assetsAudioPlayer
//                                       .seekBy(Duration(seconds: -10));
//                                 },
//                                 child: Text('-10'),
//                               ),
//                               const SizedBox(
//                                 width: 12,
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   playerProvider.assetsAudioPlayer
//                                       .seekBy(Duration(seconds: 10));
//                                 },
//                                 child: Text('+10'),
//                               ),
//                             ],
//                           )
//                         ],
//                       );
//                     }),
//                   ],
//                 );
//               }),
//               const SizedBox(
//                 height: 20,
//               ),
//               playerProvider.assetsAudioPlayer.builderCurrent(
//                   builder: (BuildContext context, Playing? playing) {
//                 return SongsSelector(
//                   audios: playerProvider.audios,
//                   onPlaylistSelected: (myAudios) {
//                     playerProvider.assetsAudioPlayer.open(
//                       Playlist(audios: myAudios),
//                       showNotification: true,
//                       headPhoneStrategy:
//                           HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
//                       audioFocusStrategy: const AudioFocusStrategy.request(
//                           resumeAfterInterruption: true),
//                     );
//                   },
//                   onSelected: (myAudio) async {
//                     try {
//                       await playerProvider.assetsAudioPlayer.open(
//                         myAudio,
//                         autoStart: true,
//                         showNotification: true,
//                         playInBackground: PlayInBackground.enabled,
//                         audioFocusStrategy: const AudioFocusStrategy.request(
//                             resumeAfterInterruption: true,
//                             resumeOthersPlayersAfterDone: true),
//                         headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
//                         notificationSettings: NotificationSettings(
//                           seekBarEnabled: false,
//                           stopEnabled: true,
//                           customStopAction: (player) {
//                             player.stop();
//                           },
//                           prevEnabled: false,
//                           customNextAction: (player) {
//                             print('next');
//                           },
//                           customStopIcon:
//                               AndroidResDrawable(name: 'ic_stop_custom'),
//                           customPauseIcon:
//                               AndroidResDrawable(name: 'ic_pause_custom'),
//                           customPlayIcon:
//                               AndroidResDrawable(name: 'ic_play_custom'),
//                         ),
//                       );
//                     } catch (e) {
//                       print(e);
//                     }
//                   },
//                   playing: playing,
//                 );
//               }),
//               /*
//                   PlayerBuilder.volume(
//                       player: _assetsAudioPlayer,
//                       builder: (context, volume) {
//                         return VolumeSelector(
//                           volume: volume,
//                           onChange: (v) {
//                             _assetsAudioPlayer.setVolume(v);
//                           },
//                         );
//                       }),
//                    */
//               /*
//                   PlayerBuilder.forwardRewindSpeed(
//                       player: _assetsAudioPlayer,
//                       builder: (context, speed) {
//                         return ForwardRewindSelector(
//                           speed: speed,
//                           onChange: (v) {
//                             _assetsAudioPlayer.forwardOrRewind(v);
//                           },
//                         );
//                       }),
//                    */
//               /*
//                   PlayerBuilder.playSpeed(
//                       player: _assetsAudioPlayer,
//                       builder: (context, playSpeed) {
//                         return PlaySpeedSelector(
//                           playSpeed: playSpeed,
//                           onChange: (v) {
//                             _assetsAudioPlayer.setPlaySpeed(v);
//                           },
//                         );
//                       }),
//                    */
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }