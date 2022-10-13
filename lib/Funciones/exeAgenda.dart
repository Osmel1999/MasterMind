import 'package:flutter/material.dart';
import '../Pages/contactPage.dart';

class ExeAgenda {
  agendaActions(BuildContext context, String action) {
    action == "callPage"
        ? Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const ContactsPage(),
            ))
        : null;
  }
}
