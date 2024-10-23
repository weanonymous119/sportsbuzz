import 'dart:math';

import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/consts/firebase_const.dart';
import 'package:signature/consts/list.dart';
import 'package:signature/controllers/auth_controller.dart';

import 'package:signature/views/home_screen/home.dart';
import 'package:signature/widgets_common/applogo_widget.dart';
import 'package:signature/widgets_common/bg_widget.dart';
import 'package:signature/widgets_common/custom_textfeild.dart';
import 'package:signature/widgets_common/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool? isCheck = false;

  var Controller = Get.put(AuthController());

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  //var passwordRetypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Join the Signature Sports".text.fontFamily(bold).white.size(22).make(),
              20.heightBox,

              Obx(
                    ()=>Column(
                  children: [
                    customTextFeild(hint: nameHint,title: name,controller: nameController,isPass: false),
                    customTextFeild(hint: emailHint,title: email,controller: emailController,isPass: false),
                    customTextFeild(hint: passwordHint,title: password,controller: passwordController,isPass: true),
                    //customTextFeild(hint: passwordHint,title: retypePassword,controller: passwordRetypeController,isPass: true),

                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: (){}, child: forgotpass.text.make())),

                    5.heightBox,
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.red,
                            value: isCheck,
                            onChanged: (newValue ){
                            setState(() {
                              isCheck = newValue;
                            });
                            }
                        ),
                        10.widthBox,
                        Expanded(
                          child: RichText(text: TextSpan(
                            children: [
                              TextSpan(text: "I agree to ",style: TextStyle(fontFamily: regular,color: fontGrey)),
                              TextSpan(text: termAndcond,style: TextStyle(fontFamily: regular,color: redColor)),
                              TextSpan(text: "& ",style: TextStyle(fontFamily: regular,color: fontGrey)),
                              TextSpan(text: privacyPolicy,style: TextStyle(fontFamily: regular,color: redColor))
                            ]
                          )),
                        ),
                      ],
                    ),
                    5.heightBox,
                    Controller.isloading.value ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    ):ourButton(color: isCheck == true ? redColor: lightGrey,title: signup,textColor: whiteColor,onPress: ()async{

                      if(isCheck != false){
                        Controller.isloading(true);
                        try{
                          await Controller.signupMethod(context: context,email: emailController.text.toString(),password: passwordController.text.toString(),).then((value){
                            return Controller.storeUserData(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString(),
                              name: nameController.text.toString(),
                            );
                          }).then((value) =>{
                            VxToast.show(context, msg:"Login Successful"),
                            Get.offAll(Home()),
                          });
                        }
                        catch(e){
                          auth.signOut();
                          VxToast.show(context, msg: e.toString());
                          print("error 1 = ${e.toString()}");
                          Controller.isloading(false);

                        }
                      }


                      print("email = ${emailController.text}");
                      print("password = ${passwordController.text}");
                      print("name = ${nameController.text}");
                     // print("retype = ${passwordRetypeController.text}");
                    }).box.width(context.screenWidth-50).make(),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        alreadyHaveAccount.text.color(fontGrey).make(),
                        login.text.color(redColor).make().onTap(() {
                          Get.back();
                        })

                      ],
                    ),
                    20.heightBox,




                  ],


                ).box.white.rounded.padding(EdgeInsets.all(16)).width(context.screenWidth - 70).shadowSm.make(),
              ),


            ],
          ),
        ),

      ),
    );
  }
}
