import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:master_app/Pages/PartnerViewer/teamx.dart';
import 'package:master_app/Provider/homeProvider.dart';
import 'package:master_app/widgets/multiWidget/partners.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../widgets/multiWidget/toDo.dart';

class Dynamix extends StatefulWidget {
  Map<String, Widget> boxes;
  Dynamix({super.key, required this.boxes});

  @override
  State<Dynamix> createState() => _DynamixState();
}

class _DynamixState extends State<Dynamix> {
  // final scrollDirection = Axis.vertical;

  // Map<String, Widget> boxes = const

  CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final boxDy = Provider.of<DynamicBoxProvider>(context);
    var media = MediaQuery.of(context).size;
    return SizedBox(
      // height: media.height * 0.4,
      // width: media.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              height: media.height * 0.04,
              child:
                  title(widget.boxes.keys.toList(), boxDy.boxPosition, media)),
          SizedBox(
            // height: media.height * 0.36,
            // width: media.width * 0.95,
            child: CarouselSlider.builder(
              options: CarouselOptions(
                  height: media.height * 0.36,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: ((index, reason) async {
                    controller.animateToPage(index);
                    print("${widget.boxes.keys.toList()[index]}: $index");
                    boxDy.changeIndex(index);
                  })),
              itemCount: widget.boxes.length,
              itemBuilder: (context, i, pageViewIndex) {
                String key = widget.boxes.keys.toList()[i];
                return widget.boxes[key]!;
              },
            ),
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
