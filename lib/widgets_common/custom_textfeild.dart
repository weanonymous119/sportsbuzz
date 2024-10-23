import 'package:signature/consts/colors.dart';
import 'package:signature/consts/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../consts/strings.dart';


Widget customTextFeild({String? title, String? hint, controller,isPass,initial}){

  TextEditingController _controller = new TextEditingController();


  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        title!.text.color(redColor).fontFamily(semibold).size(16).make(),
      5.heightBox,
      TextFormField(
        obscureText: isPass,
        controller: controller,
        initialValue: initial,

        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontFamily: semibold,
            color: textfieldGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: lightGrey,
          filled: true,

          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red
            )
          )
        ),
      ),
      5.heightBox
    ],
  );
}



