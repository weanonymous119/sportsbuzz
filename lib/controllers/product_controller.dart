
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/consts/firebase_const.dart';
import 'package:signature/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/consts/consts.dart';

class ProductController extends GetxController{



  var quantity =0.obs;

  var colorIndex = 0.obs;

  List subcat = [];

  var totalPrice = 0.obs;

  var isFav = false.obs;




  getSubCategories({title})async{

    subcat.clear();

    var data = await rootBundle.loadString("lib/services/category_model.json");

    var decode = categoryModelFromJson(data);
    print("decode = ${decode}");

    var s = decode.categories.where((element) => element.name==title).toList();
    print("s = ${s}");

    for(var e in s[0].subcategory){
      subcat.add(e);
    }
    print("list = ${subcat}");
  }



  changeColorIndex(index){
    colorIndex = index;
  }


  increaseQuantity(totalQuantity){
    if(quantity.value<totalQuantity){
      quantity.value++;
    }

  }

  decreaseQuantity(){
    if(quantity.value>0){
      quantity.value--;
    }
  }


  calculateTotalPrice(price){

    totalPrice.value = price*quantity.value;

  }


  addToCart({title,img,sellername,color,qty,tprice,context,vendorID})async{
    await firestore.collection(cartCollection).doc().set({
        'title':title,
        'img':img,
        'sellername':sellername,
        'color':color,
        'qty':qty,
        'vendor_id': vendorID,
        'tprice':tprice,
        'added_by':currentUser!.uid
    }).catchError((error){
      VxToast.show(context, msg: error.toString());
    });
  }


  resetValues(){
    totalPrice.value=0;
    quantity.value=0;
    colorIndex.value=0;

  }

  addtoWishList(docID,context)async{
    await firestore.collection(productsCollection).doc(docID).set({
      'p_wishlist':FieldValue.arrayUnion([currentUser!.uid])
    },SetOptions(merge: true));

    isFav(true);
    VxToast.show(context, msg: "Added to wishlist");

  }



  removeFromWishList(docID,context)async{
    await firestore.collection(productsCollection).doc(docID).set({
      'p_wishlist':FieldValue.arrayRemove([currentUser!.uid])
    },SetOptions(merge: true));

    isFav(false);
    VxToast.show(context, msg: "Removed from wishlist");
  }


  checkIfFav(data)async{
    if(data['p_wishlist'].contains(currentUser!.uid)){
      isFav(true);
    }else{
      isFav(false);
    }

  }

}