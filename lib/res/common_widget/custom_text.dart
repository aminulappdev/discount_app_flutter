// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:discount_me_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? decorationThickness;
  CustomText({super.key,
    required this.title,
    this.fontSize=12, 
    this.color=Colors.black,
    this.fontWeight=FontWeight.normal,
    this.decoration=TextDecoration.none,
    this.decorationColor=Colors.deepOrangeAccent,
    this.decorationThickness = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.urbanist(
        fontSize: fontSize.sp(context),
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor:decorationColor,
        decorationThickness: decorationThickness
      ),
    );
  }
}



