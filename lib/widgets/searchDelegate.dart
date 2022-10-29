import 'package:flutter/material.dart';
import 'package:master_app/Provider/dreamProvider.dart';
import 'package:provider/provider.dart';

class SearchDream extends StatefulWidget {
  const SearchDream({super.key});

  @override
  State<SearchDream> createState() => _SearchDreamState();
}

// TextEditingController searchController = TextEditingController();
// String query = "";
// List<String> sinTextoEscrito = [];
// bool isSearching = false;

class _SearchDreamState extends State<SearchDream> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dreamProvider = Provider.of<DreamProvider>(context, listen: false);
    var media = MediaQuery.of(context).size;
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
          dreamProvider.searchDream(text);
        },
      ),
    );
  }
}
