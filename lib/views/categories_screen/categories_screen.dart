import 'package:signature/consts/consts.dart';
import 'package:signature/consts/list.dart';
import 'package:signature/controllers/product_controller.dart';
import 'package:signature/views/categories_screen/categories_details.dart';
import 'package:signature/widgets_common/bg_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var Controller = Get.put(ProductController());

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(

          title: categories.text.fontFamily(bold).make(),
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: GridView.builder(
          shrinkWrap: true,
          itemCount: 9,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisSpacing: 8,crossAxisSpacing: 8,mainAxisExtent: 200),
              itemBuilder: (context,index){
            return Column(
              children: [
                Image.asset(categoriesImages[index],height: 120,width: 200,fit: BoxFit.cover,),
                10.heightBox,
                "${categoriesLsit[index]}".text.align(TextAlign.center).color(darkFontGrey).make(),
              ],

            ).box.rounded.white.clip(Clip.antiAlias).outerShadowSm  .make().
            onTap(() {
              Controller.getSubCategories(title:categoriesLsit[index]);
              Get.to(()=>CategoryDetails(title: categoriesLsit[index]));
            });
              }),
        ),
      )
    );
  }
}
