import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/services/firestore_services.dart';
import 'package:signature/views/orders_screen/orders_details.dart';
import 'package:signature/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

Widget orderStatus({icon,color,title,showdone}){
  return ListTile(
    leading: Icon(icon,color:color).box.border(color:color).roundedSM.padding(EdgeInsets.all(4)).make(),

    trailing: SizedBox(
      height: 100,
        width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          "$title".text.color(darkFontGrey).make(),
           showdone ? const Icon(
             Icons.done,color: Colors.red,
           ):
           Container(),

        ],
      ),
    ),
  );
}