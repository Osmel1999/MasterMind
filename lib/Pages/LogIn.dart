import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:master_app/Pages/SignIn/DreamPage.dart';
import 'package:master_app/Preferencias/sharedPeference.dart';
import 'package:master_app/Provider/Firebase/fire_store.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';

import '../Provider/Firebase/fire_auth.dart';
import '../Provider/bigData.dart';
import '../Provider/dreamProvider.dart';
import '../navegationPage.dart';
import 'SignIn/DreamPage.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State createState() => SignInState();
}

class SignInState extends State<SignIn> {
  late FireStore fireStore;
  late BigData bigData;
  late FireAuth fireAuth;
  late DreamProvider dreamProvider;
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // if (bigData.bigData["User"]["Email"].isNotEmpty) {
      //   if (bigData.bigData["User"]["Mentor"] != null) {
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute<void>(
      //           builder: (BuildContext context) => const NavigationPage()),
      //     );
      //   } else {
      //     // ignore: use_build_context_synchronously
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute<void>(
      //           builder: (BuildContext context) => const Dreams()),
      //     );
      //   }
      // }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _launchURL() async {
    Uri url = Uri.parse(
        'https://teseraktonline.wordpress.com/politica-de-privacidad/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildBody(Size media) {
    fireStore = Provider.of<FireStore>(context);
    bigData = Provider.of<BigData>(context);
    fireAuth = Provider.of<FireAuth>(context);
    dreamProvider = Provider.of<DreamProvider>(context);

    // if (fireAuth.currentUser != null || fireAuth.appleUser != null) {
    // autoSignIn = true;
    // if (fireAuth.currentUser != null) {
    //   fireAuth.signInWithGoogle(fireAuth.currentUser);
    // }
    if (bigData.bigData["User"]["Mentor"] != null) {
      return const NavigationPage();
    } else {
      return Column(
        children: [
          SizedBox(
              height: media.height * 0.5,
              // width: media.width * 0.,
              child: _video()),
          SizedBox(
            height: media.height * 0.25,
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
            height: media.height * 0.06,
            width: media.width * 0.6,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
              ),
              onPressed: () async {
                fireAuth.signIn(
                    context, bigData, fireStore, dreamProvider, "Google");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      // decoration: BoxDecoration(color: Colors.blue),
                      child: Image.asset('assets/google_icon.png',
                          fit: BoxFit.cover)),
                  const Text('Ingresar'),
                ],
              ),
            ),
          ),
          (defaultTargetPlatform == TargetPlatform.iOS)
              ? Container(
                  margin: EdgeInsets.only(top: media.height * 0.02),
                  height: media.height * 0.06,
                  width: media.width * 0.6,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () async => await fireAuth.signIn(
                        context, bigData, fireStore, dreamProvider, "Apple"),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.apple_rounded),
                        Text('Ingresar'),
                      ],
                    ),
                  ),
                )
              : Container(),
          TextButton(
            child: const Text("Privacy Policy"),
            onPressed: () => _launchURL(),
          )
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

    return Material(
        child: Container(color: Colors.white, child: _buildBody(media)));
  }
}
