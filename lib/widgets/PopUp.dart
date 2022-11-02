import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Provider/bigData.dart';

void popUp(BuildContext context, Size media, BigData bigdata, Widget widget) {
  showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: media.height * 0.4,
          width: media.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: widget),
        );
      });
}
