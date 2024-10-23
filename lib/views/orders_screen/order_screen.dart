import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/services/firestore_services.dart';
import 'package:signature/views/orders_screen/orders_details.dart';
import 'package:signature/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';
import 'orders_details.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: "My Orders".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),

      body: StreamBuilder(
        stream: FireStoreServices.getAllOrders(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,){
              if(!snapshot.hasData){
                return Center(
                   child: loadingIndicator(),
                );
              }

              else if(snapshot.data!.docs.isEmpty){
                return "No Orders".text.color(darkFontGrey).makeCentered();
              }
              else{

              var data = snapshot.data!.docs;

              //print(data['order_confirmed'].toString());




                return ListView.builder(
                  itemCount: data.length,
                    itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      leading: "${index+1}".text.fontFamily(bold).color(darkFontGrey).xl.make(),
                      title: data[index]['order_code'].toString().text.color(redColor).make(),
                      subtitle: data[index]['total_amount'].toString().numCurrency.text.fontFamily(bold).make(),
                      trailing: IconButton(onPressed: (){
                        Get.to(()=>orderDetails());

                      }, icon: Icon(Icons.arrow_forward_ios_rounded,color: darkFontGrey,)),

                    );
                    }
                );
              }
          }
      ),
    );
  }
}
