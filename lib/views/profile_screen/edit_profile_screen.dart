import 'dart:io';

import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/consts/firebase_const.dart';
import 'package:signature/consts/images.dart';
import 'package:signature/controllers/profile_controller.dart';
import 'package:signature/services/firestore_services.dart';
import 'package:signature/widgets_common/bg_widget.dart';
import 'package:signature/widgets_common/custom_textfeild.dart';
import 'package:signature/widgets_common/our_button.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {


  final dynamic data;



  const EditProfileScreen({Key? key,required this.data}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {

    var Controller = Get.find<ProfileController>();

    var Controllerw = Get.put(ProfileController());



    return bgWidget(
      child: Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
            stream: FireStoreServices.getsUser(currentUser!.uid),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (!snapshot.hasData) {
                return Center(
                  child:CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  ),
                );
              }

              else{




                print("data = ${snapshot.data!.docs}");

                var data = snapshot.data!.docs[0];



                return Obx(()=>

                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [







                          data['imageUrl']=='' && Controller.profileImagePath.isEmpty
                              ?Image.asset(imgProfile2 ,width: 100,fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make()
                          : data['imageUrl']!='' && Controller.profileImagePath.isEmpty
                          ? Image.network(data['imageUrl'],width: 100,).box.roundedFull.clip(Clip.antiAlias).make()
                              : Image.file(File(Controller.profileImagePath.value,),
                            width: 100,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make(),





                          10.heightBox,
                          ourButton(color: redColor,onPress: (){

                            Controller.PickImage(context: context);

                          },textColor: whiteColor,title: "Change"),
                          Divider(),
                          20.heightBox,

                          customTextFeild(hint: name, title: name, isPass: false,controller: Controller.nameController),
                          10.heightBox,
                          customTextFeild(hint:password, title: oldpass, isPass: true,controller: Controller.oldpassController),
                          10.heightBox,
                          customTextFeild(hint:password, title: newpass, isPass: true,controller: Controller.newpassController),
                          20.heightBox,

                          Controller.isloading==true ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          ) : SizedBox(
                              width: context.screenWidth-60,
                              child: ourButton(color: redColor,onPress: ()async{

                                Controller.isloading = true;


                                //if image is not select

                                if(Controller.profileImagePath.value.isNotEmpty){
                                  await Controller.uploadProfileImage();
                                }
                                else{
                                  Controller.profileImageLink = data['imageUrl'];
                                }


                                //if old password matches

                                if(data['password'] == Controller.oldpassController.text){


                                  Controller.changeAuthPassword(
                                      email: data['email'],
                                      password: Controller.oldpassController.text,
                                    newpassword: Controller.newpassController.text,
                                  );

                                  await Controller.updateProfile(
                                    imgUrl: Controller.profileImageLink,
                                    name: Controller.nameController.text,
                                    password: Controller.newpassController.text,
                                  );
                                  VxToast.show(context, msg: "Updated");

                                }
                                else{
                                  VxToast.show(context, msg: "Wrong Old Password");
                                  Controller.isloading=false;
                                }








                              },textColor: whiteColor,title: "Save")),
                        ],
                      ).box.white.shadowSm.padding(EdgeInsets.all(16)).margin(EdgeInsets.only(top: 50,left: 12,right: 12)).rounded.make(),
                    ),
                );
              }

            }
        )
      )
    );
  }
}
