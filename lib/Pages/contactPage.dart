import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:master_app/Provider/contactProvider.dart';
import 'package:master_app/widgets/contactWidgets/constumers.dart';
import 'package:master_app/widgets/contactWidgets/prospect.dart';
import 'package:master_app/widgets/contactWidgets/waitting.dart';
import 'package:provider/provider.dart';

import '../widgets/buscadorTXT.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

CarouselController controller = CarouselController();

Map<String, Widget> listas = {
  "Prospectos": Prospect(),
  "consumidores": Costumers(),
  "En espera": Waitting(),
};

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    // ContactProvider contactProvider = ContactProvider();
    var media = MediaQuery.of(context).size;
    return SizedBox(
      height: media.height * 0.75,
      width: media.width,
      child: Column(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: media.height * 0.04,
                child: title(
                    listas.keys.toList(), contactProvider.contactIndex, media),
              ),
              SearchWidget(),
            ],
          ),
          // Divider(),
          CarouselSlider.builder(
            options: CarouselOptions(
                height: media.height * 0.63,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: ((index, reason) async {
                  controller.animateToPage(index);
                  contactProvider.changeIndex(index);
                })),
            itemCount: listas.length,
            itemBuilder: (context, i, pageViewIndex) {
              String key = listas.keys.toList()[i];
              return listas[key]!;
            },
          ),
        ],
      ),
    );
  }

  Widget title(List<String> titles, int index, Size media) {
    return CarouselSlider.builder(
        carouselController: controller,
        options: CarouselOptions(
          aspectRatio: 50 / 4,
          viewportFraction: 0.4,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
        ),
        itemCount: titles.length,
        itemBuilder: (context, i, pageViewIndex) {
          return Container(
            alignment: Alignment.center,
            width: media.width,
            // color: Colors.blue,
            child: Text(
              titles[i],
              style: TextStyle(
                color:
                    (i == index) ? Colors.black : Colors.black.withOpacity(0.2),
                fontWeight: (i == index) ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        });
  }
}
