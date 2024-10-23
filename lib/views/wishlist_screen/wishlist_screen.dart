import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/consts/firebase_const.dart';
import 'package:signature/services/firestore_services.dart';
import 'package:signature/widgets_common/loading_indicator.dart';
import 'package:signature/consts/consts.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: "My Wishlists".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),

      body: StreamBuilder(
          stream: FireStoreServices.getAllWishlist(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,){
            if(!snapshot.hasData){
              return Center(
                child: loadingIndicator(),
              );
            }

            else if(snapshot.data!.docs.isEmpty){
              return "No Wishlists".text.color(darkFontGrey).makeCentered();
            }
            else{
              var data = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                  itemBuilder: (BuildContext, int index){
                  return Expanded(
                    child: ListTile(
                        leading: Image.network("${data[index]['p_imgs'][0]}",width: 80,),
                        title: "${data[index]['p_name']}"
                            .text.fontFamily(semibold).size(16).make(),
                        subtitle: "${data[index]['p_price']}".numCurrency.text.color(redColor).fontFamily(semibold).make(),

                        trailing: IconButton(onPressed: () async{
                          //FireStoreServices.deleteDocument(data[index].id);

                          await firestore.collection(productsCollection).doc(data[index].id).set({
                            'p_wishlist':FieldValue.arrayRemove([currentUser!.uid])

                          },SetOptions(merge: true));
                        }, icon: Icon(Icons.favorite_outlined,color: redColor,))
                    ),
                  );
                  },
              );
            }
          }
      ),
    );
  }
}
