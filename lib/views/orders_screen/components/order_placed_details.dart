
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';



Widget Order_abu({String? tet1,String ? tet2,data,index,d1,d2}){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "$tet1".text.fontFamily(semibold).make(),
            "$d1".text.color(Colors.red).fontFamily(semibold).make(),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "$tet2".text.fontFamily(semibold).make(),
            "$d2".text.color(Colors.red).fontFamily(semibold).make(),








          ],
        ),
      ],
    ),
  );
}











