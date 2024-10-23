import 'package:signature/consts/consts.dart';
import 'package:signature/consts/list.dart';
import 'package:signature/controllers/product_controller.dart';
import 'package:signature/services/firestore_services.dart';
import 'package:signature/views/categories_screen/categories_details.dart';
import 'package:signature/views/categories_screen/item_details.dart';
import 'package:signature/widgets_common/bg_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/widgets_common/loading_indicator.dart';


class CategoryDetails extends StatefulWidget {
  final String? title;
  const CategoryDetails({Key? key,required this.title}) : super(key: key);

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switchCategory(widget.title);

  }


  switchCategory(title){
    if(Controller.subcat.contains(title)){
      productMethod = FireStoreServices.getSubCategory(title);
    }
    else{
      productMethod = FireStoreServices.getProducts(title);
    }
  }

  var Controller = Get.find<ProductController>();

  dynamic productMethod;

  @override
  Widget build(BuildContext context) {





    print(Controller.subcat);

    return bgWidget(
        child: Scaffold(
          appBar: AppBar(

            title: widget.title!.text.fontFamily(bold).make(),
          ),

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,

                child: Row(
                  children: List.generate(Controller.subcat.length, (index) => "${Controller.subcat[index]}".text.size(12).fontFamily(semibold).color(darkFontGrey).makeCentered().
                  box.white.rounded.size(120, 60).margin(EdgeInsets.symmetric(horizontal: 4)).make()
                  .onTap(() {
                    switchCategory("${Controller.subcat[index]}");
                    setState(() {

                    });
                  })
                  ),
                ),
              ),

              20.heightBox,



              StreamBuilder(
                stream: productMethod,

                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){


                    if (!snapshot.hasData) {
                      return Expanded(
                        child: Center(
                          child:loadingIndicator(),
                        ),
                      );
                    }
                    else if(snapshot.data!.docs.isEmpty){
                      return Expanded(
                        child: "No Products Found".text.color(darkFontGrey).makeCentered(),
                      );
                    }

                    else{
                      var data = snapshot.data!.docs;


                      return



                          // items container



                          Expanded(child: GridView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:data.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 250,mainAxisSpacing: 8,crossAxisSpacing: 8),
                              itemBuilder:(context,index){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(data[index]['p_imgs'][0],width: 200,height: 150,fit: BoxFit.cover,),
                                    "${data[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey  ).make(),
                                    10.heightBox,

                                    "${data[index]['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).make(),
                                  ],
                                ).box.margin(EdgeInsets.symmetric(horizontal: 4)).outerShadowSm.padding(EdgeInsets.all(12)).roundedSM.white.make().
                                onTap(() {
                                  Controller.checkIfFav(data[index]);
                                  Get.to(ItemDetails(title: "${data[index]['p_name']}",data: data[index],));
                                });
                              }));

                    }

                  }
              ),
            ],
          )
        )
    );
  }
}
