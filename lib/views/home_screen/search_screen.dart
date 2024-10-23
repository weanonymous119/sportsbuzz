import 'package:flutter/material.dart';
import 'package:signature/consts/consts.dart';
import 'package:signature/consts/firebase_const.dart';
import 'package:signature/controllers/product_controller.dart';
import 'package:signature/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature/views/categories_screen/item_details.dart';
import 'package:signature/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class SearchScreeen extends StatelessWidget {


  final String? title;


  const SearchScreeen({Key?  key,this.title }) : super(key: key);


  @override
  Widget build(BuildContext context) {


    var controller = Get.find<ProductController>();

    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: title!.text.color(Colors.black).make(),
      ),
      body: FutureBuilder(
        future: FireStoreServices.searchProduct(title),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if (!snapshot.hasData) {
              return Center(
                child:loadingIndicator(),
              );
            }
            else if(snapshot.data!.docs.isEmpty){
              return Center(
                child: "No Products Found".text.color(darkFontGrey).make(),
              );
            }

            else

              {
                var data = snapshot.data!.docs;
                print(data[0]['p_name']);
                var filter = data.where((element) => element['p_name'].toString().toLowerCase().contains(title!.toLowerCase()),).toList();


                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView(


                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 8,crossAxisSpacing: 8,mainAxisExtent: 300),

                    children: filter.mapIndexed((currentValue, index)=>Column(
                      children: [
                        Image.network(filter[index]['p_imgs'][0],width: 200,height: 200,fit: BoxFit.cover,),
                        Spacer(),
                        "${filter[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey  ).make(),
                        10.heightBox,

                        "${filter[index]['p_price']}".text.color(redColor).fontFamily(bold).make()


                      ],
                    ).box.margin(EdgeInsets.symmetric(horizontal: 4)).shadowMd.padding(EdgeInsets.all(12)).roundedSM.white.make()
                        .onTap(() {
                            //controller.checkIfFav(allproducts[index]);
                            Get.to(ItemDetails(title: "${filter[index]['p_name']}",data: filter[index],));

                    })
                    ).toList(),

                  ),
                );
              }

          },
      ),
    );
  }
}
