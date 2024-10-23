import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/consts/list.dart';
import 'package:signature/views/orders_screen/components/order_placed_details.dart';
import 'package:signature/views/orders_screen/components/order_status.dart';
import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/services/firestore_services.dart';
import 'package:signature/widgets_common/loading_indicator.dart';
import 'package:signature/consts/consts.dart';
import 'order_screen.dart';
import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/services/firestore_services.dart';
//import 'package:signature/views/orders_screen/orders_details.dart';
//import 'package:signature/widgets_common/loading_indicator.dart';
//import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;







class orderDetails extends StatelessWidget {
  const orderDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var a;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: "Order Details".text.fontFamily(semibold).color(darkFontGrey).make(),
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
                return

                  ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index){
                        a=(data[index]['orders'].length);
                        return

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView (
                              child: Column(
                                children: [
                                  orderStatus(color: redColor, icon: Icons.done, title: "Placed", showdone:data[index]['order_placed']),
                                  orderStatus(color: Colors.blue, icon: Icons.thumb_up, title: "Confirmed", showdone:data[index]['order_confirmed']),
                                  orderStatus(color: Colors.yellow, icon: Icons.car_crash, title: "On Delivary", showdone:data[index]['order_on_delivery']),
                                  orderStatus(color: Colors.purple, icon: Icons.done_all_rounded, title: "Delivered", showdone:data[index]['order_delivered']),


                                  Divider(),

                                  10.heightBox,


                                  Column(
                                    children: [
                                      Order_abu(
                                          data: data,
                                          index: index,
                                          tet1: "Order Details",
                                          tet2: "Shipping Method",
                                          d1: data[index]['order_code'],
                                          d2: data[index]['shipping_method']
                                      ),

                                      Order_abu(
                                          data: data,
                                          index: index,
                                          tet1: "Order Date",
                                          tet2: "Payment Method",
                                          d1: intl.DateFormat().add_yMd().format((data[index]['order_date'].toDate())),
                                          d2: data[index]['payment_method']
                                      ),


                                      Order_abu(
                                          data: data,
                                          index: index,
                                          tet1: "Payment Status",
                                          tet2: "Delivary Status ",
                                          d1: 'Unpaid',
                                          d2: "Order Placed"
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 130,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  "Shipping Address".text.fontFamily(bold).make(),
                                                  "${data[index]['order_by_name']}".text.make(),
                                                  "${data[index]['order_by_email']}".text.make(),
                                                  "${data[index]['order_by_address']}".text.make(),
                                                  "${data[index]['order_by_city']}".text.make(),
                                                  //"${data[index]['order_by_country']}".text.make(),
                                                  "${data[index]['order_by_state']}".text.make(),
                                                  "${data[index]['order_by_postalcode']}".text.make(),
                                                  "${data[index]['order_by_phone']}".text.make(),

                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  "Total Amount".text.fontFamily(semibold).make(),
                                                  "${data[index]['total_amount']}".text.color(Colors.red).fontFamily(bold).make(),


                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ).box.outerShadowMd.white.make(),



                                  Divider(),

                                  10.heightBox,

                                  "Order Details".text.size(16).color(darkFontGrey).fontFamily(semibold).makeCentered(),

                                  10.heightBox,

                                 //a=data[index]['orders'].length,



                                  ListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: List.generate(1, (index){
                                      return
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Order_abu(
                                                data: data,
                                                index: index,
                                                tet1: data[index]['orders'][index]['title'].toString(),
                                                tet2: data[index]['orders'][index]['tprice'].toString().numCurrency,
                                                d1: "${data[index]['orders'][index]['qty']}x",
                                                d2: "Refundable"
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              child: Container(

                                                width: 30,
                                                height: 20,
                                                color: Color(data[index]['orders'][index]['color']),
                                              ),
                                            ),

                                            Divider(),
                                          ],
                                        );
                                    }).toList(),

                                  ).box.outerShadowMd.white.margin(EdgeInsets.only(bottom: 4)).make(),

                                  20.heightBox,
























                                ],
                              ),
                            ),
                          );
                      }
                  );




              }


            }
        )
    );
  }
}




