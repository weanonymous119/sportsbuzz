import 'package:signature/consts/consts.dart';
import 'package:signature/consts/firebase_const.dart';
import 'package:signature/views/auth_screen/login_screen.dart';
import 'package:signature/views/home_screen/home.dart';
import 'package:signature/widgets_common/applogo_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  changeScreen(){
    Future.delayed(Duration(seconds: 3),()
    {
      //Get.to(const LoginScreen());

      auth.authStateChanges().listen((User? user) {
        if(user == null && mounted){
          Get.to(()=>LoginScreen());
        }
        else{
          Get.to(()=>Home());
        }
      });

    });
  }





  @override

  void initState(){
    changeScreen();
    super.initState();
  }




  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          children: [
             Align(alignment:Alignment.topLeft,
                 child: Image.asset(icSplashBg,width: 300,)),
            20.heightBox,
            applogoWidget()
          ],
        ),
      ),
    );
  }
}
