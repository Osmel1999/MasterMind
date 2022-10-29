import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MentorSelector extends StatefulWidget {
  @override
  _MentorSelectorState createState() => _MentorSelectorState();
}

class _MentorSelectorState extends State<MentorSelector> {
  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: 650,
        child: ListView(
          children: [
            SizedBox(
              height: media.height * 15.625 / 100,
            ),
            Container(
              padding: EdgeInsets.only(left: media.height * 0.78125 / 100),
              child: Text(
                'Invita a tu mentor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black45,
                  fontFamily: 'Ubuntu',
                  fontSize: media.height * 4.0625 / 100,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: media.height * 10.9375 / 100,
            ),
            _emailCampo(media),
            SizedBox(height: media.height * 1.5625 / 100),
            _boton(media),
          ],
        ),
      ),
    );
  }

  Widget _emailCampo(Size media) {
    return StreamBuilder(
      // stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.white60,
          child: SizedBox(
            width: media.height * 48.4375 / 100,
            height: media.height * 7.8125 / 100,
            child: const TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
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
              // onChanged: bloc.changeEmail,
            ),
          ),
        );
      },
    );
  }

  Widget _boton(Size media) {
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
          onPressed: (snapshot.hasData)
              ? () => _agregarmeAlMentor(context, media)
              : null,
        ),
      );
    });
  }

  // Aqui colocamos la funcion que agrega mi correo al de mi mentor, el que agregue

  _agregarmeAlMentor(context, Size media) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(
              vertical: media.height * 43.75 / 100,
              horizontal: media.height * 23.828125 / 100),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[900]!),
          ),
        );
      },
    );
    // bloc.dataUsuario.datosProgress['Mentor@'] = bloc.email.toLowerCase();
    // bloc.guardarDataBaseProgress();
    // bloc.uploadProgressToMentor(
    //     '${bloc.pref.email}', bloc.email, bloc.dataUsuario.datosProgress);
    // Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder: (BuildContext context) => DataMinerPage()));
    // bloc.pref.stepInscription = '1';
  }
}
