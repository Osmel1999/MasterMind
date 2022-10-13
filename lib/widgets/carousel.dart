import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

List<String> drm = [
  "https://revistasumma.com/wp-content/uploads/2015/05/Audi-Car-.jpg",
  "https://p4.wallpaperbetter.com/wallpaper/506/718/378/world-1920x1080-statue-jesus-wallpaper-preview.jpg"
];

class _CarouselState extends State<Carousel> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return CarouselSlider.builder(
      itemCount: drm.length,
      options: CarouselOptions(
        height: media.height * 0.25,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      itemBuilder: (BuildContext context, int index, int pageViewIndex) =>
          CachedNetworkImage(
        imageUrl: drm[index],
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
          color: Colors.blueAccent,
        )),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
