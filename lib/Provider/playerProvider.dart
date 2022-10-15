import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class PlayerProvider with ChangeNotifier {
  late AssetsAudioPlayer assetsAudioPlayer;
  String audioPath = "";
  bool isPLaying = true;
  List<String> trending = [
    "https://media2.4life.com/images/RecognitionPhoto/2019/5ef45469-adde-41c9-89b6-852f784630e0_20191008121024.JPG?w=400&h=400&mode=crop&anchor=topcenter&scale=both&quality=75",
    "https://media2.4life.com/images/RecognitionPhoto/2022/55dbcfd1-45b8-49bc-b620-b20c3ddcac18.jpg?w=400&h=400&mode=crop&anchor=topcenter&scale=both&quality=75",
  ];
  Map dbAudios = {
    "Lo puedes ver?": {
      "Autor": "Juan Rosado",
      "Imagen":
          "https://media2.4life.com/images/RecognitionPhoto/2019/5ef45469-adde-41c9-89b6-852f784630e0_20191008121024.JPG?w=400&h=400&mode=crop&anchor=topcenter&scale=both&quality=75",
    },
    "Alimenta tu sueño, no te rindas": {
      "Autor": "Herminio Nevarez",
      "Imagen":
          "https://media2.4life.com/images/RecognitionPhoto/2022/55dbcfd1-45b8-49bc-b620-b20c3ddcac18.jpg?w=400&h=400&mode=crop&anchor=topcenter&scale=both&quality=75",
    }
  };
  List<Audio> audios = <Audio>[
    // Audio.network(
    //   'https://files.freemusicarchive.org/storage-freemusicarchive-org/music/Music_for_Video/springtide/Sounds_strange_weird_but_unmistakably_romantic_Vol1/springtide_-_03_-_We_Are_Heading_to_the_East.mp3',
    //   metas: Metas(
    //     id: 'Online',
    //     title: 'Online',
    //     artist: 'Florent Champigny',
    //     album: 'OnlineAlbum',
    //     // image: MetasImage.network('https://www.google.com')
    //     image: const MetasImage.network(
    //         'https://image.shutterstock.com/image-vector/pop-music-text-art-colorful-600w-515538502.jpg'),
    //   ),
    // ),
  ];

  PlayerProvider() {
    initPlayer();
  }

  initPlayer() {
    assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    audios.isNotEmpty ? openPlayer() : null;
  }

  void openPlayer() async {
    await assetsAudioPlayer.open(
      Playlist(audios: audios, startIndex: 0),
      showNotification: true,
      autoStart: true,
      playInBackground: PlayInBackground.enabled,
    );
    audioPath = audios[0].path;
    notifyListeners();
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    print('dispose');
    super.dispose();
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  playOrPause() {
    assetsAudioPlayer.playOrPause();
    isPLaying = (isPLaying) ? false : true;
    notifyListeners();
  }

  changeAudio(String title) async {
    audios = <Audio>[
      Audio.network(
        'https://files.freemusicarchive.org/storage-freemusicarchive-org/music/Music_for_Video/springtide/Sounds_strange_weird_but_unmistakably_romantic_Vol1/springtide_-_03_-_We_Are_Heading_to_the_East.mp3',
        metas: Metas(
          id: 'Online',
          title: title,
          artist: dbAudios[title]["Autor"],
          album: '',
          // image: MetasImage.network('https://www.google.com')
          image: MetasImage.network(dbAudios[title]["Imagen"]),
        ),
      ),
    ];
    audioPath = "";
    openPlayer();
    notifyListeners();
  }
}
