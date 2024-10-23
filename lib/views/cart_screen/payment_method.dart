import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/consts/list.dart';
import 'package:signature/controllers/cart_controller.dart';
import 'package:signature/views/home_screen/home_screen.dart';
import 'package:signature/views/orders_screen/order_screen.dart';
import 'package:signature/widgets_common/loading_indicator.dart';
import 'package:signature/widgets_common/our_button.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/controllers/home_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import '../auth_screen/login_screen.dart';
import 'cart_screen.dart';



class PaymentMethods extends StatefulWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  @override
  Widget build(BuildContext context) {

    var Controller = Get.find<CartController>();



    return Obx(()=>
         Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: " Choose Payment Method".text.fontFamily(semibold).color(darkFontGrey).make(),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: Controller.placingOrder.value ? Center(
            child: loadingIndicator(),
          ) :ourButton(
            onPress: ()async{

              if(Controller.paymentIndex.value==2){

                await Controller.placeMyOrder(orderPaymentMethod: paymentMethods[Controller.paymentIndex.value],
                    totlaAmount: Controller.totalP.value
                );
                await Controller.clearCart();
                VxToast.show(context, msg: "Order placed Successfully");
                Get.to(()=>OrderScreen());

              }







            },
            color: redColor,
            textColor: whiteColor,
            title: "Place my order",
          ),
        ),

        body:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(()=>
              Column(
              children: List.generate(paymentMethodsImg.length, (index){
                return GestureDetector(
                  onTap: (){
                    Controller.changePaymentIndex(index);

                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12 ),
                          border: Border.all(
                              color: Controller.paymentIndex.value == index ? Colors.black : Colors.transparent,
                              width: 5
                          )
                    ),
                    margin: EdgeInsets.only(bottom: 8),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.asset(
                          paymentMethodsImg[index],
                          width: double.infinity,
                          height: 120,fit: BoxFit.cover ,
                          colorBlendMode: Controller.paymentIndex.value == index ? BlendMode.darken : BlendMode.color,
                          color: Controller.paymentIndex.value == index ? Colors.black.withOpacity(0.5): Colors.transparent


                        ),
                        Controller.paymentIndex.value == index ? Transform.scale(
                          scale: 1.3,

                          child: Checkbox(
                            activeColor: Colors.green ,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                              ),
                              value: true,
                              onChanged: (value){}),
                        ): Container(),


                        Positioned(
                          bottom: 10,
                            right: 10,
                            child: paymentMethods[index].text.black.fontFamily(semibold).size(16 ).make()
                        ),
                      ],
                    )
                  ),
                );
              })
            ),
          ),
        )
      ),
    );
  }




}
