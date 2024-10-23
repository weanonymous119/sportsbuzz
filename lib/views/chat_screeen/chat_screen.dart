import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/consts/firebase_const.dart';
import 'package:signature/controllers/chat_controller.dart';
import 'package:signature/services/firestore_services.dart';
import 'package:signature/views/chat_screeen/components/sender_bubble.dart';
import 'package:get/get.dart';
import 'package:signature/widgets_common/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/consts/list.dart';
import 'package:signature/controllers/product_controller.dart';
import 'package:signature/services/firestore_services.dart';
import 'package:signature/views/categories_screen/categories_details.dart';
import 'package:signature/views/categories_screen/item_details.dart';
import 'package:signature/widgets_common/bg_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/widgets_common/loading_indicator.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var Controller = Get.put(ChatController());


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: "${Controller.friendName}".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),


      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(()=>
                Controller.isloading.value  ? Center(child: loadingIndicator(),):

                Expanded(child:
           StreamBuilder(
               stream: FireStoreServices.getChatMessages(Controller.chatDocId.toString()),
                 builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,){
                  if(!snapshot.hasData){
                    return Center(
                      child: loadingIndicator(),
                    );
                  }
                  else if(snapshot.data!.docs.isEmpty){
                    print(snapshot.data!.docs);
                    return Center(
                      child: "Send a message...".text.color(darkFontGrey).make(),
                    );
                  }
                  else{
                    return  ListView(
                      children: snapshot.data!.docs.mapIndexed((currentValue, index){

                        var data = snapshot.data!.docs[index];
                        return Align(
                            alignment: data['uid']==currentUser!.uid ? Alignment.centerRight:Alignment.centerLeft,
                            child: senderBubble(data));
                      }).toList()
                    );
                  }
                 }
           )
              ),
            ),

            10.heightBox,
            
            Row(
              children: [
                Expanded(child: TextFormField(
                  controller: Controller.msgController,
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                  ),
                )),
                IconButton(onPressed: (){
                  Controller.sendMsg(Controller.msgController.text);
                  Controller.msgController.clear();
                  
                }, icon: Icon(Icons.send),color: redColor,)
              ],
            ).box.height(80).padding(EdgeInsets.all(12)).margin(EdgeInsets.only(bottom: 8)).make(),
          ],

        ),
      ),
    );
  }
}
