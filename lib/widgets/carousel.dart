import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  List<String>? item;
  double height;
  double aspectRatio;
  double viewportFraction;
  bool? autoPlay;
  bool? enableInfiniteScroll;
  Carousel({
    super.key,
    this.item,
    required this.height,
    required this.aspectRatio,
    required this.viewportFraction,
    this.autoPlay,
    this.enableInfiniteScroll,
  });

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

    List<String> item = (widget.item != null) ? widget.item! : drm;
    return CarouselSlider.builder(
      itemCount: item.length,
      options: CarouselOptions(
        height: widget.height,
        aspectRatio: widget.aspectRatio,
        viewportFraction: widget.viewportFraction,
        initialPage: 0,
        enableInfiniteScroll: widget.enableInfiniteScroll ?? true,
        reverse: false,
        autoPlay: widget.autoPlay ?? true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      itemBuilder: (BuildContext context, int index, int pageViewIndex) =>
          ZoomIn(
        duration: const Duration(milliseconds: 900),
        child: GestureDetector(
          onTap: widget.item != null ? () {} : null,
          child: CachedNetworkImage(
            imageUrl: item[index],
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
        ),
      ),
    );
  }
}
