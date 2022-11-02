import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Provider/bigData.dart';
import '../../Provider/dreamProvider.dart';
import '../../widgets/searchDelegate.dart';
import 'GolasCollectorPage.dart';

class Dreams extends StatefulWidget {
  const Dreams({super.key});

  @override
  State<Dreams> createState() => _DreamsState();
}

class _DreamsState extends State<Dreams> {
  @override
  Widget build(BuildContext context) {
    final dreamProvider = Provider.of<DreamProvider>(context);
    final bigData = Provider.of<BigData>(context);
    var media = MediaQuery.of(context).size;
    return Material(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: media.height * 0.05, horizontal: media.width * 0.05),
            child: Column(
              children: [
                const SearchDream(),
                SizedBox(
                  height: media.height * 0.8,
                  // width: ,
                  child: GridView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                    ),
                    itemCount: dreamProvider.listSuggest.length,
                    itemBuilder: (context, index) {
                      String url =
                          dreamProvider.d2B[dreamProvider.listSuggest[index]];
                      return GestureDetector(
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: url,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    image: DecorationImage(
                                      // colorFilter:
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                )),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              ((bigData.bigData["Sueños"] != null) &&
                                      (bigData.bigData["Sueños"][dreamProvider
                                              .listSuggest[index]] !=
                                          null))
                                  ? Center(
                                      child: ZoomIn(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: const Icon(
                                          Icons.favorite_rounded,
                                          color: Colors.red,
                                          size: 35,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          onTap: () async {
                            bool aExist = await bigData.addDream(
                                key: dreamProvider.listSuggest[index],
                                value: url);
                            (aExist == true)
                                ? bigData.deleteDream(
                                    key: dreamProvider.listSuggest[index])
                                : null;
                          });
                    },
                  ),
                )
              ],
            ),
          ),
          (bigData.bigData["Sueños"] != null &&
                  bigData.bigData["Sueños"].isNotEmpty)
              ? Positioned(
                  bottom: 10,
                  // right: 17,
                  child: SizedBox(
                    width: media.width,
                    child: Center(
                      child: SizedBox(
                        width: media.width * 0.8,
                        child: ElevatedButton(
                          child: const Text("Siguiente"),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => MetasPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
