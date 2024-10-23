import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/consts/firebase_const.dart';
import 'package:signature/controllers/home_controller.dart';

class ChatController extends GetxController{

  @override
  void onInit() {
    getChatId();
    super.onInit();
  }

  var  chats = firestore.collection(chatsCollection);

  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username ;
  var currentId = currentUser!.uid;


  var msgController = TextEditingController();

  dynamic chatDocId;

  var isloading = false.obs;

  getChatId()async{
    print("Hello Abubakr");

    isloading(true);

    await chats.where('user',isEqualTo: {
      friendId:null,
      currentId:null

    }
    ).limit(1).get().then((QuerySnapshot snapshot){

      try{
        print("sussfull 1");
        if(snapshot.docs.isNotEmpty){
          print("data = ${snapshot.docs}");
          chatDocId=snapshot.docs.single.id;
        }

        else{
          chats.add ({

            'created_on':null,
            'last_msg':'',
            'users':{friendId:null,currentId:null},
            'toId':'',
            'fromId':'',
            'friend_name':friendName,
            'sender_name':senderName,

          }
          ).then((value) => {
            chatDocId = value.id,
          });

        }

      }catch(e){
        print("error = ${e.toString()}");
      }


    });
    isloading(false);
  }


  sendMsg(String msg)async{

    print("Hello Abubakr send msg");



    try{
      if(msg.trim().isNotEmpty){
        chats.doc(chatDocId).update({
          'created_on': FieldValue.serverTimestamp(),
          'last_msg':msg,
          'toId':friendId,
          'fromId':currentId,
        });

        chats.doc(chatDocId).collection(messageCollection).doc().set({
          'created_on': FieldValue.serverTimestamp(),
          'msg':msg,
          'uid':currentId,
        });
        print("succesfull");



      }

    }catch(e){
      print("error = ${e.toString()}");
    }


  }



}