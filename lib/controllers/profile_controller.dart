import 'dart:convert';
import 'dart:io';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:signature/consts/consts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:signature/consts/firebase_const.dart';


class ProfileController extends GetxController {
  var profileImagePath = "".obs;
  final picker = ImagePicker();

  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();


  var profileImageLink = "";

  var isloading = false;
  Future<File?> PickImage({context}) async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if(pickedFile==null) return null;
      // Do something with the picked image file


      var imageFile = File(pickedFile.path);

      profileImagePath.value = imageFile.path;


    }
    on PlatformException catch(e){
      VxToast.show(context, msg: e.toString());
    }

    }


    uploadProfileImage()async{

    var filename = basename(profileImagePath.value);
    var destinarion = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destinarion );
    await ref.putFile(File(profileImagePath.value));

    profileImageLink = await ref.getDownloadURL();

    }


    updateProfile({name,password,imgUrl})async{
    
     var store = firestore.collection(userCollection).doc(currentUser!.uid);
     store.set({await 'name':name, 'password':password, 'imageUrl': imgUrl},SetOptions(merge: true));
     isloading=false;
    }


    changeAuthPassword({email,password,newpassword}) async{

    final cred = EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(cred).then((value){
      currentUser!.updatePassword(newpassword);
    }).catchError((error){
      print(error.toString());
    });

    }
}