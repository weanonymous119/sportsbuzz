import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/consts/firebase_const.dart';

class HomeController extends GetxController{


  @override
  void onInit() {
    getusername();
    super.onInit();
  }

  var currentNavIndex = 0.obs;


  var username = '';


  var searchController = TextEditingController();

  getusername()async{
    var n = await firestore.collection(userCollection).where('id',isEqualTo: currentUser!.uid).get().then((value){
      if(value.docs.isNotEmpty){
        return value.docs.single['name'];
      }
    });

  username = n;


  }

}