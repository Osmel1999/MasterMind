import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:master_app/Pages/SignIn/DreamPage.dart';
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
  Widget _buildBody(Size media) {
    final fireAuth = Provider.of<FireAuth>(context);
    final bigData = Provider.of<BigData>(context);
    final dreamProvider = Provider.of<DreamProvider>(context);
    FireStore fireStore = FireStore();
    if (fireAuth.currentUser != null) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
      // return Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: <Widget>[
      //     ListTile(
      //       leading: GoogleUserCircleAvatar(
      //         identity: fireAuth.currentUser!,
      //       ),
      //       title: Text(fireAuth.currentUser!.displayName ?? ''),
      //       subtitle: Text(fireAuth.currentUser!.email),
      //     ),
      //     const Text('Signed in successfully.'),
      //     Text(fireAuth.currentUser!.displayName!),
      //     ElevatedButton(
      //       onPressed: fireAuth.handleSignOut,
      //       child: const Text('SIGN OUT'),
      //     ),
      //     const ElevatedButton(
      //       onPressed: null,
      //       child: Text('REFRESH'),
      //     ),
      //   ],
      // );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          SizedBox(
            height: media.height * 0.05,
            width: media.width * 0.35,
            child: ElevatedButton(
              onPressed: () async {
                await fireAuth.handleSignIn(context);
                if ((await fireStore.bajarDataCloud(
                        "mj@mail.com", "Datos Personales"))
                    .isNotEmpty) {
                  await bigData.migData(FireStore(), "17asanjuan@gmail.com");
                  await bigData.uploadMigData(
                      FireStore(), "17asanjuan@gmail.com");
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const NavigationPage(),
                    ),
                  );
                } else {
                  // Lo iniciamos dentro de Phlow (Planification Flow).
                  await dreamProvider.dowloadDreams(fireStore);
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const Dreams(),
                    ),
                  );
                }
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(media),
        ));
  }
}
