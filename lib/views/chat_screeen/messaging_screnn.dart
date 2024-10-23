import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/services/firestore_services.dart';
import 'package:signature/views/chat_screeen/chat_screen.dart';
import 'package:signature/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: "My Messages".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),

      body: StreamBuilder(
          stream: FireStoreServices.getAllMessages(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,){
            if(!snapshot.hasData){
              return Center(
                child: loadingIndicator(),
              );
            }

            else if(snapshot.data!.docs.isEmpty){
              return "No Messsages".text.color(darkFontGrey).makeCentered();
            }
            else{
              var data = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                          itemCount: data.length,
                            itemBuilder: (BuildContext,int index){
                              return Card(
                                child: ListTile(
                                  onTap: (){
                                    Get.to(()=>ChatScreen(),
                                        arguments: [
                                        data[index]['friend_name'].toString(),
                                        data[index]['toId'].toString(),
                                        ]
                                    );
                                  },

                                 leading: CircleAvatar(
                                   backgroundColor: Colors.red,
                                   child: Icon(Icons.person,color: Colors.white,),
                                 ),
                                  title: "${data[index]['friend_name']}".text.color(darkFontGrey).fontFamily(semibold).make(),
                                  subtitle: "${data[index]['last_msg']}".text.color(darkFontGrey).fontFamily(semibold).make(),
                                ),
                              );
                            }
                        ),
                    )
                  ],
                ),
              );
            }
          }
      ),
    );
  }
}
