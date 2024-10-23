import 'package:signature/consts/consts.dart';
import 'package:signature/consts/firebase_const.dart';
import 'package:signature/controllers/cart_controller.dart';
import 'package:signature/services/firestore_services.dart';
import 'package:signature/views/cart_screen/shipping_screen.dart';
import 'package:signature/widgets_common/bg_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:signature/widgets_common/loading_indicator.dart';
import 'package:signature/widgets_common/our_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../consts/list.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import '../auth_screen/login_screen.dart';
import '../categories_screen/categories_details.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    
    var Controller = Get.put(CartController());
    //var Controller1 = Get.put(ProfileController());
    
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 60,
          width: context.screenWidth-60,
          child: ourButton(
              color: redColor,
              onPress: ()async{
                Get.to(()=>ShippingDetails());
                //await Get.put(AuthController().signoutMethod(context));
                //Get.offAll(LoginScreen());
              },
              textColor: whiteColor,
              title: "Proceed to Shipping"
          )
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: "Shopping cart".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),

      body: StreamBuilder(
        stream: FireStoreServices.getCart(currentUser!.uid),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){


            if (!snapshot.hasData) {
              return Center(
                child:loadingIndicator(),
              );
            }
            else if(snapshot.data!.docs.isEmpty){
              return Center(
                child: "Cart is empty".text.color(darkFontGrey).make(),
              );
            }
            else{
              var data =  snapshot.data!.docs;
              Controller.calculate(data);
              Controller.productSnapshots = data;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(child:
                    Container(
                      child: ListView.builder(
                        itemCount: data.length,
                          itemBuilder: (BuildContext context,int index){
                          return ListTile(
                            leading: Image.network("${data[index]['img']}",width: 80,),
                            title: "${data[index]['title']} (x${data[index]['qty']})"
                                .text.fontFamily(semibold).size(16).make(),
                            subtitle: "${data[index]['tprice']}".numCurrency.text.color(redColor).fontFamily(semibold).make(),

                            trailing: IconButton(onPressed: (){
                              FireStoreServices.deleteDocument(data[index].id);
                            }, icon: Icon(Icons.delete,color: redColor,))
                          );
                          }
                      ),
                    ),

                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Total Price".text.fontFamily(semibold).color(darkFontGrey).make(),
                        Obx(()=>"${Controller.totalP.value}".numCurrency.text.fontFamily(semibold).color(redColor).make()),
                      ],
                    ).box.padding(EdgeInsets.all(12)).color(lightGolden).width(context.screenWidth-40).roundedSM.make(),

                    10.heightBox,

                  ],
                ),
              );
            }
    }
      )
    );
  }
}
