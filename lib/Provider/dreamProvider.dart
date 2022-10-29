import 'package:flutter/material.dart';

import 'Firebase/fire_store.dart';

class DreamProvider with ChangeNotifier {
  Map<String, dynamic> d2B = {};
  List<String> listSuggest = [];

  void searchDream(String query) {
    listSuggest = [];
    if (query.isNotEmpty) {
      d2B.forEach((k, v) {
        if ((k.length >= query.length) &&
            (k.substring(0, query.length) == query)) {
          listSuggest.add(k);
        }
      });
      if (listSuggest.isEmpty) {
        d2B.forEach((k, v) {
          if (k.toLowerCase().contains(query.toLowerCase())) {
            listSuggest.add(k);
          }
        });
      }
    } else {
      listSuggest = [];
    }
    notifyListeners();
  }

  Future<void> dowloadDreams(FireStore fireStore) async {
    d2B = await fireStore.bajarDataCloud("Global", "db_sueños");
    listSuggest = d2B.keys.toList();
  }
}
