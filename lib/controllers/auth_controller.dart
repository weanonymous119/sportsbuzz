



import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:signature/consts/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:signature/consts/firebase_const.dart';




class  AuthController extends GetxController{

  //textControler

  var isloading = false.obs;


  var emailController = TextEditingController();
  var passwordController = TextEditingController();


  Future LoginInMethod({context,email,password}) async {


    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);

    } on FirebaseAuthException catch(e){
      VxToast.show(context, msg: e.toString());
      print("error 2 ${e.toString()}");

    }
  }



  // signup method

  Future <UserCredential?>signupMethod ({email,password,context}) async {
    UserCredential? userCredential;

    try{
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    }
    catch(e){
      VxToast.show(context, msg: e.toString());
      print("error 3 ${e.toString()}");
    }
    return userCredential;
  }



  // storing data method

  storeUserData({name,password,email }) async{

    DocumentReference store = await firestore.collection(userCollection).doc(currentUser!.uid);
    store.set({'name': name, 'password':password,'email':email,'imageUrl':'','id':currentUser!.uid,
      'cart_count':'00',
      'whishlist_count':'00',
      'order_count':'00',




    }).then((value) => print("User Addes"));

  }

  signoutMethod(context) async{
    try{
      await auth.signOut();
    }
    catch(e){
      VxToast.show(context, msg:e.toString());
      print("error 4 ${e.toString()}");
    }
  }


}





