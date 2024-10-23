import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/consts/firebase_const.dart';
import 'package:signature/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/controllers/home_controller.dart';

class CartController extends GetxController{

  var totalP = 0.obs;



  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();



  var rng = new Random().nextInt(900000)+100000;





  var products = [];

  var vendors = [];

  var paymentIndex = 0.obs;




  late dynamic productSnapshots;

  var placingOrder = false.obs;

  calculate(data){
    totalP.value = 0;
    for(var i=0; i< data.length ; i++){
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  changePaymentIndex(index){
    paymentIndex.value = index;
  }

    placeMyOrder({required orderPaymentMethod,required totlaAmount})async{

    placingOrder(true);
    await getProductDetails();


    await firestore.collection(ordersCollection).doc().set({
      'order_date':FieldValue.serverTimestamp(),
      'order_by':currentUser!.uid,
      'order_by_name':Get.find<HomeController>().username,
      'order_by_email':currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state':stateController.text,
      'order_by_city':cityController.text,
      'order_by_phone':phoneController.text,
      'order_by_postalcode':postalcodeController.text,
      'shipping_method':"Home Delivary",
      'payment_method': orderPaymentMethod,
      'order_placed' : true,
      'order_code' : rng.toString(),
      'order_confirmed':false,
      'order_delivered':false,
      'order_on_delivery':false,
      'total_amount': totlaAmount,
      'orders': FieldValue.arrayUnion(products),
      'vendors':FieldValue.arrayUnion(vendors)
    });
    placingOrder(false);
  }


  getProductDetails(){
    products.clear();
    vendors.clear();
     for(var i=0; i < productSnapshots.length;i++ ){
       products.add({
         'color':productSnapshots[i]['color'],

         'img':productSnapshots[i]['img'],

         'vendor_id':productSnapshots[i]['vendor_id'],

         'tprice':productSnapshots[i]['tprice'],

         'qty':productSnapshots[i]['qty'],

         'title': productSnapshots[i]['title']
       });
       vendors.add(productSnapshots[i]['vendor_id']);

     }
     print(products);
  }


  clearCart(){
    for(var i=0; i < productSnapshots.length;i++ ){
        firestore.collection(cartCollection).doc(productSnapshots[i].id).delete();
    }

  }

}