import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_app/Pages/Purchase/MarketPage.dart';
import 'package:master_app/Provider/Firebase/fire_store.dart';
import 'package:provider/provider.dart';

import '../../Provider/bigData.dart';
import '../../Provider/navProvider.dart';
import '../../navegationPage.dart';

class MentorSelector extends StatefulWidget {
  @override
  _MentorSelectorState createState() => _MentorSelectorState();
}

class _MentorSelectorState extends State<MentorSelector> {
  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);
    final bigdata = Provider.of<BigData>(context);
    final fireStore = Provider.of<FireStore>(context);
    final navProv = Provider.of<NavigationProvider>(context);

    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: 650,
        child: ListView(
          children: [
            SizedBox(
              height: media.height * 0.15,
            ),
            Container(
              padding: EdgeInsets.only(left: media.height * 0.07),
              child: Text(
                'Invita a tu mentor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black45,
                  fontFamily: 'Ubuntu',
                  fontSize: media.height * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: media.height * 0.01,
            ),
            _emailCampo(media, bigdata),
            SizedBox(height: media.height * 0.015),
            _boton(media, bigdata, fireStore, navProv),
          ],
        ),
      ),
    );
  }

  Widget _emailCampo(Size media, BigData bigdata) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.white60,
      child: SizedBox(
        width: media.height * 0.48,
        height: media.height * 0.078,
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.account_circle_outlined),
            hintText: 'Email',
            labelStyle: TextStyle(fontFamily: 'Ubuntu'),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
            ),
            // counterText: snapshot.data,
            // errorText: snapshot.error,
          ),
          onChanged: (query) => bigdata.changeMentor(query),
        ),
      ),
    );
  }

  Widget _boton(Size media, BigData bigdata, FireStore fireStore,
      NavigationProvider navProv) {
    return StreamBuilder(
        // stream: bloc.emailStream,
        builder: (BuildContext contex, AsyncSnapshot snapshot) {
      return Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(right: 5.0),
        // ignore: deprecated_member_use
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            //   splashColor: Colors.yellow[800],
            // textColor: Colors.black45,
            // borderSide: BorderSide(color: Colors.yellow[800]!, width: 2.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: Text('Siguiente'),
          onPressed: (bigdata.bigData["User"]["Mentor"] != null)
              ? () => _agregarmeAlMentor(bigdata, fireStore, navProv)
              : null,
        ),
      );
    });
  }

  // Aqui colocamos la funcion que agrega mi correo al de mi mentor, el que agregue

  _agregarmeAlMentor(
      BigData bigdata, FireStore fire, NavigationProvider navProv) {
    bigdata.save();
    fire.updateDataCloud(
        fire.endpoint, bigdata.bigData["User"]["Email"], bigdata.bigData);
    bigdata.sendMentor(fire);
    navProv.indexNav = 1;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NavigationPage(),
      ),
    );
  }
}
