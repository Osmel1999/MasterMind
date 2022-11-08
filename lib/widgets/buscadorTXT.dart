import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:master_app/Provider/bigData.dart';
import 'package:provider/provider.dart';

import '../Provider/contactProvider.dart';

class SearchWidget extends StatefulWidget {
  String listType;
  SearchWidget({super.key, required this.listType});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

// TextEditingController searchController = TextEditingController();
// String query = "";
// List<String> sinTextoEscrito = [];
// bool isSearching = false;

class _SearchWidgetState extends State<SearchWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider =
        Provider.of<ContactProvider>(context, listen: false);
    var media = MediaQuery.of(context).size;
    final bigdata = Provider.of<BigData>(context);
    // bool isSearching = searchController.text.isNotEmpty;
    // contactProvider.listaSugerida = (query.isEmpty)
    //     ? sinTextoEscrito
    //     : contactProvider.mapaContact.keys
    //         .toList()
    //         .where((p) => p.toLowerCase().contains(query.toLowerCase()))
    //         .toList();
    return Container(
      height: media.height * 0.07,
      width: media.width * 0.95,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: TextFormField(
        cursorWidth: 2,
        cursorHeight: 20,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          fillColor: Colors.white54,
          // labelText: 'Buscar contacto',
          labelStyle: TextStyle(fontFamily: 'Ubuntu'),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.indigo,
            size: 20.0,
          ),
        ),
        // controller: searchController,
        onChanged: (text) {
          contactProvider.searchContact(text, bigdata, widget.listType);
        },
      ),
    );
  }
}
