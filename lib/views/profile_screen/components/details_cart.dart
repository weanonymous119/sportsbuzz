import 'package:signature/consts/colors.dart';
import 'package:signature/consts/consts.dart';
import 'package:flutter/cupertino.dart';

Widget Details_Cart(width,String? count,String? title){
  return  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      count!.text.fontFamily(bold).color(darkFontGrey).size(16).make(),
      5.heightBox,
      title!.text.color(darkFontGrey).make(),
    ],
  ).box.rounded.white.width(width).height(70).padding(EdgeInsets.all(4)).make();
}