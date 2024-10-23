import 'dart:math';

import 'package:signature/consts/colors.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/consts/firebase_const.dart';
import 'package:signature/controllers/home_controller.dart';
import 'package:signature/controllers/product_controller.dart';
import 'package:signature/services/firestore_services.dart';
import 'package:signature/views/categories_screen/item_details.dart';
import 'package:signature/views/home_screen/components/featured_button.dart';
import 'package:signature/views/home_screen/search_screen.dart';
import 'package:signature/widgets_common/home_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signature/widgets_common/loading_indicator.dart';
import '../../consts/list.dart';
import 'package:signature/consts/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class HomeScreen extends StatelessWidget {



  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width>=600;
    bool isMobile(BuildContext context) => MediaQuery.of(context).size.width<600;

    var controller = Get.find<HomeController>();
    var Controller = Get.put(ProductController());



    return Container(
      padding: EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              color: lightGrey,
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search).onTap(() {
                    if(controller.searchController.text.isNotEmpty){
                      Get.to(()=>SearchScreeen(title: controller.searchController.text,));
                      //controller.searchController.clear();
                    }

                  }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchanything,
                  hintStyle: TextStyle(color: textfieldGrey)

                ),
              ),
            ),

            // Swiper brands

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [

                    if(isDesktop(context))
                      VxSwiper.builder(
                        aspectRatio: 16/9,
                        autoPlay: true,
                        height: 350,
                        enlargeCenterPage: true,
                        itemCount: slidersList.length, itemBuilder: (context,index){
                      return Image.asset(slidersList[index],width: 1000,
                        fit: BoxFit.fill,
                      ).box.rounded.clip(Clip.antiAlias).margin(EdgeInsets.symmetric(horizontal: 8)).make();
                    }
                    ),

                    if(isMobile(context))
                      VxSwiper.builder(
                          aspectRatio: 16/9,
                          autoPlay: true,
                          height: 150,
                          enlargeCenterPage: true,
                          itemCount: slidersList.length, itemBuilder: (context,index){
                        return Image.asset(slidersList[index],width: 1000,
                          fit: BoxFit.fill,
                        ).box.rounded.clip(Clip.antiAlias).margin(EdgeInsets.symmetric(horizontal: 8)).make();
                      }
                      ),



                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(2, (index) => homeButton(width: context.screenWidth/2.5,
                        height: context.screenHeight*0.15,
                        icon: index ==0 ? icTodaysDeal : icFlashDeal,
                        title: index==0 ? todayDeal: flashsale,
                      )
                      ),
                    ),

                    10.heightBox,

                    if(isDesktop(context))
                      VxSwiper.builder(
                        aspectRatio: 16/9,
                        autoPlay: true,
                        height: 350,
                        enlargeCenterPage: true,
                        itemCount: secondslidersList.length, itemBuilder: (context,index){
                      return Image.asset(secondslidersList[index],
                        width: 1000,
                        fit: BoxFit.fill,
                      ).box.rounded.clip(Clip.antiAlias).margin(EdgeInsets.symmetric(horizontal: 8)).make();
                    }
                    ),

                    if(isMobile(context))
                      VxSwiper.builder(
                          aspectRatio: 16/9,
                          autoPlay: true,
                          height: 150,
                          enlargeCenterPage: true,
                          itemCount: secondslidersList.length, itemBuilder: (context,index){
                        return Image.asset(secondslidersList[index],
                          width: 1000,
                          fit: BoxFit.fill,
                        ).box.rounded.clip(Clip.antiAlias).margin(EdgeInsets.symmetric(horizontal: 8)).make();
                      }
                      ),

                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(3, (index) => homeButton(width: context.screenWidth/3.5,
                        height: context.screenHeight*0.15,
                        icon: index ==0 ? icTopCategories : index==1 ? icBrands : icTopSeller,
                        title: index==0 ? topCategories: index == 1 ? brands : topSellers,
                      )
                      ),
                    ),

                    20.heightBox,
                    // Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: featuresCategories.text.color(darkFontGrey).size(18).fontFamily(semibold).make()
                    // ),
                    //
                    // 20.heightBox,
                    
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: List.generate(3, (index) => Column(
                    //       children: [
                    //
                    //         featuredButton(icon: featuredImage1[index],title: featuredTitle1[index]),
                    //         10.heightBox,
                    //         featuredButton(icon: featuredImage2[index],title: featuredTitle2[index]),
                    //
                    //       ],
                    //     )).toList(),
                    //   ),
                    // ),


                    // featured product
                     20.heightBox,

                    Container(
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: redColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredProdcut.text.white.fontFamily(bold).size(18).make(),
                          10.heightBox,
                          
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                                future: FireStoreServices.getFeaturedProduct(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child:loadingIndicator(),
                                    );
                                  }
                                  else if(snapshot.data!.docs.isEmpty){
                                    return Center(
                                      child: "Featured is empty".text.color(darkFontGrey).make(),
                                    );
                                  }

                                  else{

                                    var featuredData = snapshot.data!.docs;

                                    return
                                      Row(
                                      children: List.generate(featuredData.length, (index) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.network(featuredData[index]['p_imgs'][0],width: 150,fit: BoxFit.cover,height: 130,),
                                          10.heightBox,
                                          "${featuredData[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey  ).make(),
                                          10.heightBox,

                                          "${featuredData[index]['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).make(),
                                        ],
                                      ).box.white.margin(EdgeInsets.symmetric(horizontal: 4)).roundedSM.padding(EdgeInsets.all(8)).make(),
                                      ),
                                    ).onTap(() {

                                      //Get.to(()=>featuredData[index]['p_name'][0])

                                    });
                                  }


                                }
                            )
                          )

                        ],
                      ),
                    ),


                    // third Swiper

                    //20.heightBox,

                    // VxSwiper.builder(
                    //     aspectRatio: 16/9,
                    //     autoPlay: true,
                    //     height: 150,
                    //     enlargeCenterPage: true,
                    //     itemCount: secondslidersList.length, itemBuilder: (context,index){
                    //   return Image.asset(secondslidersList[index],
                    //     fit: BoxFit.fill,
                    //   ).box.rounded.clip(Clip.antiAlias).margin(EdgeInsets.symmetric(horizontal: 8)).make();
                    // }
                    // ),


                    // all product


                    20.heightBox,

                    "All Products".text.fontFamily(bold).color(darkFontGrey).size(20).make(),
                    20.heightBox,

                    StreamBuilder(
                      stream: FireStoreServices.allProducts(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(!snapshot.hasData){
                          return loadingIndicator();
                        }
                        else{
                          var allproducts = snapshot.data!.docs;
                          return

                            GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: allproducts.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 8,crossAxisSpacing: 8,mainAxisExtent: 300) ,
                                itemBuilder:(context,index){
                                  return  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(allproducts[index]['p_imgs'][0],width: 200,height: 200,fit: BoxFit.cover,),
                                      Spacer(),
                                      "${allproducts[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey  ).make(),
                                      10.heightBox,

                                      "\Rs.${allproducts[index]['p_price']}".text.color(redColor).fontFamily(bold).make(),
                                    ],
                                  ).box.margin(EdgeInsets.symmetric(horizontal: 4)).padding(EdgeInsets.all(12)).roundedSM.white.make().onTap(() {

                                    Controller.checkIfFav(allproducts[index]);
                                    Get.to(ItemDetails(title: "${allproducts[index]['p_name']}",data: allproducts[index],));

                                  });
                                });
                        }
              }
                    )


                  ],
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}
