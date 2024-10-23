import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/controllers/cart_controller.dart';
import 'package:signature/views/cart_screen/payment_method.dart';
import 'package:signature/widgets_common/custom_textfeild.dart';
import 'package:signature/widgets_common/our_button.dart';
import 'package:get/get.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var Controller  = Get.find<CartController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: "Shipping info".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: (){

            if(Controller.addressController.text!="" //&&
                //Controller.cityController.text!="" &&
                //Controller.stateController.text!="" &&
                //Controller.postalcodeController.text!="" &&
                //Controller.phoneController.text!=""
            ){
              Get.to(()=>PaymentMethods());

            }else{
              VxToast.show(context, msg: "Please fill all the details");
            }









          },
          color: redColor,
          textColor: whiteColor,
          title: "Continue",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextFeild(hint: "Address",isPass: false,title: "Address",controller: Controller.addressController),
            customTextFeild(hint: "City",isPass: false,title: "City",controller: Controller.cityController),
            customTextFeild(hint: "State",isPass: false,title: "State",controller: Controller.stateController),
            customTextFeild(hint: "Postal Code",isPass: false,title: "Postal Code",controller: Controller.postalcodeController),
            customTextFeild(hint: "Phone",isPass: false,title: "Phone",controller: Controller.phoneController),

          ],
        ),
      ),
    );
  }
}
