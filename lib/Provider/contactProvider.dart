import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactProvider with ChangeNotifier {
  late PermissionStatus contactosStatus;
  List<Contact> contactos = [];
  Map<String, dynamic> mapaContact = {};
  List<String> listaSugerida = [];

  late bool diaChange;

  int contactIndex = 0;

  ContactProvider() {
    mapaContact.isEmpty ? getContacts() : null;
  }

  changeIndex(int i) {
    contactIndex = i;
    notifyListeners();
  }

  searchContact(String query) {
    listaSugerida = [];
    if (query.isNotEmpty) {
      mapaContact.forEach((k, v) {
        if ((k.length >= query.length) &&
            (k.substring(0, query.length) == query)) {
          listaSugerida.add(k);
        }
      });
      if (listaSugerida.isEmpty) {
        mapaContact.forEach((k, v) {
          if (k.toLowerCase().contains(query.toLowerCase())) {
            listaSugerida.add(k);
          }
        });
      }
    } else {
      listaSugerida = [];
    }
    notifyListeners();
  }

  saveContacts() {
    // Guardaremos los contactos en su respectivo mapa
  }

  getContacts() async {
    // loading();
    await checkPermission();
    if (contactosStatus.isGranted) {
      await getAllContact();
      for (int i = 0; i < contactos.length; i++) {
        if (contactos[i].phones!.isNotEmpty &&
            contactos[i].displayName! != "") {
          mapaContact[contactos[i].displayName!] =
              contactos[i].phones![0].value.toString();
        }
      }
    }
    notifyListeners();
    // return mapaContact;
  }

  checkPermission() async {
    contactosStatus = await Permission.contacts.status;
    if (!contactosStatus.isGranted) {
      contactosStatus = await Permission.contacts.request();
      print('----Permiso seleccionado: $contactosStatus ----');
      if (contactosStatus.isPermanentlyDenied) {
        // Future<bool> openAppSettings() => _handler.openAppSettings();
        print("BIG PROBLEM");
      }
    }
  }

  Future<void> getAllContact() async {
    contactos = (await ContactsService.getContacts(
            withThumbnails: false, orderByGivenName: true))
        .toList();
  }
}
