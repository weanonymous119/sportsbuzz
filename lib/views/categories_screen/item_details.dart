import 'package:signature/consts/consts.dart';
import 'package:signature/consts/list.dart';
import 'package:flutter/material.dart';
import 'package:signature/controllers/product_controller.dart';
import 'package:signature/views/chat_screeen/chat_screen.dart';

import '../../widgets_common/our_button.dart';
import 'package:get/get.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({Key? key,this.title,this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var Controller = Get.find<ProductController>();

    print("Value of Color = ${Colors.grey.value}");

    return WillPopScope(
      onWillPop: ()async{
        Controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Controller.resetValues();
            Get.back();
          }, icon:Icon(Icons.arrow_back)),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.share)),
            Obx(()=>
                IconButton(onPressed: (){
                if(Controller.isFav.value){
                  Controller.removeFromWishList(data.id,context);
                }
                else{
                  Controller.addtoWishList(data.id,context);
                }
              }, icon:Controller.isFav.value ? Icon(
                  Icons.favorite_outlined): Icon(
                  Icons.favorite_outline),
                color: Controller.isFav.value? redColor: Colors.black,
              ),
            ),
          ],
        ),

        body: Column(
          children: [
            Expanded(child: Container(
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VxSwiper.builder(
                      autoPlay: true,
                        height: 350,
                        aspectRatio: 16/9,
                        viewportFraction: 1.0,
                        itemCount: data['p_imgs'].length,
                        itemBuilder: (context,index){
                      return Image.network(data['p_imgs'][index], width:double.infinity,fit: BoxFit.cover,);
                    }
                    ),

                    // title and details
                    10.heightBox,

                    title!.text.color(darkFontGrey).fontFamily(semibold).make().box.make(),


                    // rating
                    10.heightBox,


                    VxRating(
                      value: double.parse(data['p_rating']),
                      isSelectable: false,
                      onRatingUpdate: (value){},
                      normalColor: textfieldGrey,
                      selectionColor: golden,
                      count: 5,
                      size: 25,
                     maxRating: 5,
                    ),

                     10.heightBox,

                    "${data['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).size(18).make(),

                    10.heightBox,

                    Row(

                      children: [
                        Expanded(child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Seller".text.white.fontFamily(semibold).make(),
                            5.heightBox,
                            "${data['p_seller']}".text.fontFamily(semibold).color(darkFontGrey).size(16).make(),
                          ],
                        )),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.message_rounded,color: darkFontGrey,),
                        ).onTap(() {
                          Get.to(()=>ChatScreen(),
                            arguments: [
                              data['p_seller'],
                              data['vendor_id']
                            ]
                             );
                        })
                      ],
                    ).box.height(60).padding(EdgeInsets.symmetric(horizontal: 16)).color(textfieldGrey).make(),


                    // color selection

                    20.heightBox,
                    Obx(()=>
                        Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Color : ".text.color(textfieldGrey).make(),
                              ),

                              Row(
                                children: List.generate(data['p_color'].length,
                                        (index) => Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            VxBox()
                                                .size(40, 40).roundedFull
                                                .color(Color(data['p_color'][index]).withOpacity(1.0))
                                                .margin(EdgeInsets.symmetric(horizontal: 6))
                                                .make().onTap(() {
                                              print("hellow");
                                              Controller.changeColorIndex(index.obs);
                                            }),
                                           Visibility(
                                             visible: index == Controller.colorIndex.value,
                                               child:  Icon(Icons.done,color: Colors.white,)
                                           )
                                          ],
                                        )),
                              )
                            ],
                          ).box.padding(EdgeInsets.all(8)).make(),


                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Quantity : ".text.color(textfieldGrey).make(),
                              ),

                              Obx(()=>
                              Row(
                                  children: [
                                    IconButton(onPressed: (){
                                      Controller.decreaseQuantity();
                                      Controller.calculateTotalPrice(int.parse(data['p_price']));
                                    }, icon: Icon(Icons.remove)),
                                    Controller.quantity.value.text.size(16).color(darkFontGrey).fontFamily(bold).make(),
                                    IconButton(onPressed: (){
                                      Controller.increaseQuantity(int.parse(data['p_quantity']));
                                      Controller.calculateTotalPrice(int.parse(data['p_price']));
                                    }, icon: Icon(Icons.add)),
                                    "(${data['p_quantity']} Available)".text.color(textfieldGrey).make(),
                                  ],
                                ),
                              ),

                            ],
                          ).box.padding(EdgeInsets.all(8)).make(),


                          // total


                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Total : ".text.color(textfieldGrey).make(),
                              ),

                             "${Controller.totalPrice.value}".numCurrency.text.color(redColor).size(16).fontFamily(bold).make(),

                            ],
                          ).box.padding(EdgeInsets.all(8)).make(),



                        ],
                      ).box.white.shadowSm.make(),
                    ),


                    10.heightBox,

                    "Description".text.color(darkFontGrey).fontFamily(semibold).make(),

                    10.heightBox,

                    "${data['p_desc']}".text.color(darkFontGrey).make(),




                    // button section
                    10.heightBox,


                      ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(itemDetailButton.length, (index) => ListTile(
                          title: "${itemDetailButton[index]}".text.fontFamily(semibold).color(darkFontGrey).make(),
                          trailing: Icon(Icons.arrow_forward),
                        )),
                      ),

                    20.heightBox,

                    // productyoulike.text.fontFamily(bold).size(16).color(darkFontGrey).make(),
                    //
                    // 10.heightBox,
                    //
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: List.generate(6, (index) => Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Image.asset(imgP1,width: 150,fit: BoxFit.cover,),
                    //         10.heightBox,
                    //         "Laptop 4GB/64GB".text.fontFamily(semibold).color(darkFontGrey  ).make(),
                    //         10.heightBox,
                    //
                    //         "\$600".text.color(redColor).fontFamily(bold).make(),
                    //       ],
                    //     ).box.white.margin(EdgeInsets.symmetric(horizontal: 4)).roundedSM.padding(EdgeInsets.all(8)).make(),
                    //     ),
                    //   ),
                    // )

                  ],
                ),
              ),
               ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                color: redColor,
                onPress: (){
                 if(Controller.quantity.value>0){
                   Controller.addToCart(
                     color: data['p_color'][Controller.colorIndex.value],
                     context: context,
                     vendorID: data['vendor_id'],
                     img: data['p_imgs'][0],
                     qty: Controller.quantity.value,
                     sellername: data['p_seller'],
                     title: data['p_name'],
                     tprice: Controller.totalPrice.value,);
                   VxToast.show(context, msg: "Added to cartt");
                 }
                 else{
                   VxToast.show(context, msg: "Quantity can't be 0");
                 }


                },
                textColor: whiteColor,
                title: "Add to cart",
              ),
            )
          ],
        )
      ),
    );
  }
}
