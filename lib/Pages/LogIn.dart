import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:master_app/Pages/SignIn/DreamPage.dart';
import 'package:master_app/Preferencias/sharedPeference.dart';
import 'package:master_app/Provider/Firebase/fire_store.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            height: media.height * 0.1,
            width: media.width * 0.6,
            child: Placeholder(),
          ),
          const Text('Bienvenido a Master Mind'),
          SizedBox(
            height: media.height * 0.03,
            width: media.width * 0.8,
            child: ElevatedButton(
              onPressed: () async {
                fireAuth.signIn(context, bigData, fireStore, dreamProvider);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.apple),
                  Text('Ingresar'),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final fireAuth = Provider.of<FireAuth>(context);
    return Scaffold(
        body: ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: _buildBody(media, fireAuth),
    ));
  }
}
