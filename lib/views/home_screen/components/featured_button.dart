import 'package:signature/consts/colors.dart';
import 'package:signature/consts/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:signature/views/categories_screen/categories_details.dart';


Widget featuredButton({String? title, icon}){
  return Row(
       children: [
         Image.asset(icon,width: 60,height:40,fit: BoxFit.fill,),
         10.widthBox,
          title!.text.fontFamily(semibold).color(darkFontGrey).make(),
       ],
  ).box.width(600).margin(EdgeInsets.symmetric(horizontal: 4)).white.padding(EdgeInsets.all(4)).roundedSM.outerShadowSm.make()
  .onTap(() {
    Get.to(()=>CategoryDetails(title: title));
  });
}