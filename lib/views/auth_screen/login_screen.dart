import 'package:signature/consts/consts.dart';
import 'package:signature/consts/firebase_const.dart';
import 'package:signature/consts/list.dart';
import 'package:signature/controllers/auth_controller.dart';

import 'package:signature/views/auth_screen/signup_screen.dart';
import 'package:signature/views/home_screen/home_screen.dart';
import 'package:signature/widgets_common/applogo_widget.dart';
import 'package:signature/widgets_common/bg_widget.dart';
import 'package:signature/widgets_common/custom_textfeild.dart';
import 'package:signature/widgets_common/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_screen/home.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    var Controller = Get.put(AuthController());


    return bgWidget(
        child:Scaffold(
      resizeToAvoidBottomInset: false,
    body: Center(
      child: Column(
        children: [
          (context.screenHeight * 0.1).heightBox,
           applogoWidget(),
            10.heightBox,
          "Login To Signature Sports".text.fontFamily(bold).white.size(22).make(),
          20.heightBox,

          Obx(
                ()=>Column(
              children: [
                customTextFeild(hint: emailHint,title: email,isPass: false,controller: Controller.emailController),
                customTextFeild(hint: passwordHint,title: password,isPass: true,controller: Controller.passwordController),


                Align(
                  alignment: Alignment.centerRight,
                    child: TextButton(onPressed: (){}, child: forgotpass.text.make())),


                5.heightBox,
                Controller.isloading.value ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ):ourButton(color: redColor,title: login,textColor: whiteColor,onPress: () async{

                  Controller.isloading(true);
                  try{
                    await auth.signInWithEmailAndPassword(email: Controller.emailController.text, password: Controller.passwordController.text).then((value){

                      if(value!=null) {
                        print("return value = ${value}");
                        print("login");
                        VxToast.show(context, msg: "Login");
                        Get.to(Home());
                      }
                      else{
                        print("return value = ${value}");
                        Controller.isloading(false);
                        print("error");
                      }


                    });
                  }on FirebaseAuthException catch(e){

                    VxToast.show(context, msg: e.toString());
                    print("error");
                    Controller.isloading(false);
                  }









                }).box.width(context.screenWidth-50).make(),


                5.heightBox,
                createNewAccount.text.color(fontGrey).make(),


                5.heightBox,
                ourButton(color: lightGolden,title: signup,textColor: redColor,onPress: (){
                  Get.to(SignupScreen());
                }).box.width(context.screenWidth-50).make(),

                10.heightBox,

                loginWith.text.color(fontGrey).make(),
                5.heightBox,

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:List.generate(3, (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: lightGrey,
                      radius: 25,
                      child: Image.asset(socialIconList[index],width: 30,),
                    ),
                  )),
                )

              ],


            ).box.white.rounded.padding(EdgeInsets.all(16)).width(context.screenWidth - 70).shadowSm.make(),
          ),


        ],
      ),
    ),
    ));
  }
}
