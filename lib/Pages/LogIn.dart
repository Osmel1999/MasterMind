import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:master_app/Pages/SignIn/DreamPage.dart';
import 'package:master_app/Preferencias/sharedPeference.dart';
import 'package:master_app/Provider/Firebase/fire_store.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../Provider/Firebase/fire_auth.dart';
import '../Provider/bigData.dart';
import '../Provider/dreamProvider.dart';
import '../navegationPage.dart';

class SignInDemo extends StatefulWidget {
  const SignInDemo({Key? key}) : super(key: key);

  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  FireStore fireStore = FireStore();
  final pref = PreferenciasUsuario();
  bool autoSignIn = false;
  late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    _controller = VideoPlayerController.asset('assets/gif/MasterMind.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller.play();
        _controller.setLooping(true);

        setState(() {});
      });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _buildBody(Size media, FireAuth fireAuth) {
    final bigData = Provider.of<BigData>(context);
    final dreamProvider = Provider.of<DreamProvider>(context);

    if (fireAuth.currentUser != null) {
      autoSignIn = true;
      fireAuth.signInWithGoogle(fireAuth.currentUser);
      return const NavigationPage();
    } else {
      return Column(
        children: [
          SizedBox(
              height: media.height * 0.5,
              // width: media.width * 0.,
              child: _video()),
          SizedBox(
            height: media.height * 0.3,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: media.height * 0.05),
                  child: const Text(
                    'Bienvenido a Master Mind',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: media.height * 0),
                  child: const Text(
                    'Muchas mentes, un propósito',
                    style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: media.height * 0.05,
            width: media.width * 0.6,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
              ),
              onPressed: () async {
                fireAuth.signIn(context, bigData, fireStore, dreamProvider);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      // decoration: BoxDecoration(color: Colors.blue),
                      child: Image.network(
                          'http://pngimg.com/uploads/google/google_PNG19635.png',
                          fit: BoxFit.cover)),
                  const Text('Ingresar'),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _video() {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: GestureDetector(
              child: VideoPlayer(_controller),
              onTap: () {
                // setState(() {
                //   _controller.value.isPlaying
                //       ? _controller.pause()
                //       : _controller.play();
                // });
              },
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final fireAuth = Provider.of<FireAuth>(context);
    return Material(
        child:
            Container(color: Colors.white, child: _buildBody(media, fireAuth)));
  }
}
