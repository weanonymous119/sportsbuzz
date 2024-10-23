import 'package:signature/consts/consts.dart';
import 'package:signature/controllers/home_controller.dart';
import 'package:signature/views/cart_screen/cart_screen.dart';
import 'package:signature/views/categories_screen/categories_screen.dart';
import 'package:signature/views/home_screen/home_screen.dart';
import 'package:signature/views/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:signature/widgets_common/exit_dialog.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(HomeController());

  var navbarItem = [
    BottomNavigationBarItem(icon: Image.asset(icHome,width: 26,),label: home),
    BottomNavigationBarItem(icon: Image.asset(icCategories,width: 26,),label: categories),
    BottomNavigationBarItem(icon: Image.asset(icCart,width: 26,),label: cart),
    BottomNavigationBarItem(icon: Image.asset(icProfile,width: 26,),label: account),
  ];

  var navBody = [
    HomeScreen(),
    CategoryScreen(),
    CartScreen(),
    Profile_Screen(),
  ];

    return WillPopScope(
      onWillPop: ()async{
        showDialog(
          barrierDismissible: false,
            context: context, builder: (context)=>exitDialog(context)
        );
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(()=>  Expanded(child:  navBody.elementAt(controller.currentNavIndex.value))),
          ],
        ),
        bottomNavigationBar: Obx(()=>
          BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            selectedItemColor: redColor,
              selectedLabelStyle: const TextStyle(fontFamily: semibold),
              backgroundColor: whiteColor,
              type: BottomNavigationBarType.fixed,
              items: navbarItem,
            onTap: (value){
              controller.currentNavIndex.value = value;
            }
          ),
        ),
      ),
    );
  }
}
