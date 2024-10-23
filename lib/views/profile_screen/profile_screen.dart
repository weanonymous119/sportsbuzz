import 'package:signature/consts/consts.dart';
import 'package:signature/consts/firebase_const.dart';
import 'package:signature/consts/list.dart';
import 'package:signature/controllers/auth_controller.dart';
import 'package:signature/controllers/profile_controller.dart';
import 'package:signature/services/firestore_services.dart';
import 'package:signature/views/auth_screen/login_screen.dart';
import 'package:signature/views/chat_screeen/messaging_screnn.dart';
import 'package:signature/views/orders_screen/order_screen.dart';
import 'package:signature/views/profile_screen/components/details_cart.dart';
import 'package:signature/views/profile_screen/edit_profile_screen.dart';
import 'package:signature/views/wishlist_screen/wishlist_screen.dart';
import 'package:signature/widgets_common/bg_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Profile_Screen extends StatelessWidget {
  const Profile_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var Controller = Get.put(ProfileController());

    FireStoreServices.getCounts();




    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
            stream: FireStoreServices.getsUser(currentUser!.uid),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (!snapshot.hasData) {
                return Center(
                  child:CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  ),
                );
              }

              else{

                print("data = ${snapshot.data!.docs}");

                var data = snapshot.data!.docs[0];
                print(data['name']);


                return SafeArea(
                  child: Column(
                    children: [


                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.edit,color: Colors.white,),
                            onPressed: () {

                              Controller.nameController.text = data['name'];


                              Get.to(EditProfileScreen(data: data,));
                            },
                          ),
                        ).onTap(() {}),
                      ),


                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [

                            data['imageUrl']==''

                           ? Image.asset(imgProfile2 ,width: 100,fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make()
                            : Image.network(data['imageUrl'] ,width: 60,fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make(),

                            10.widthBox,




                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data['name']}".text.fontFamily(semibold).white.make(),
                                "${data['email']}".text.white.make()
                              ],
                            )
                            ),

                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Colors.white
                                    )
                                ),
                                onPressed: ()async {
                                  await Get.put(AuthController().signoutMethod(context));
                                  Get.offAll(LoginScreen());
                                }, child: "Log out".text.fontFamily(semibold).white.make()
                            )
                          ],
                        ),
                      ),


                      5.heightBox,

                      FutureBuilder(
                        future: FireStoreServices.getCounts(),
                          builder: (BuildContext context, AsyncSnapshot snapshot){
                            if (!snapshot.hasData) {
                              return Center(
                                child:CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(redColor),
                                ),
                              );
                            }
                            else{
                              print("sdsdsd${snapshot.data}");
                              var Countdata = snapshot.data;
                              return
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Details_Cart(context.screenWidth/3.4, Countdata[0].toString(), "In your cart"),
                                    Details_Cart(context.screenWidth/3.4, Countdata[1].toString(), "In your wishlsit"),
                                    Details_Cart(context.screenWidth/3.4, Countdata[2].toString(), "Your orders"),
                                  ],
                                );
                            }

                          }
                      ),




                      // button section




                      ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context,index){
                            return Divider(
                              color: lightGrey,
                            );
                          },
                          itemCount: profileButtonsList.length,
                          itemBuilder: ( BuildContext context,int index){
                            return ListTile(
                              onTap: (){
                                switch(index){
                                  case 0:
                                    Get.to(()=>OrderScreen());
                                    break;
                                  case 1:
                                    Get.to(()=>WishlistScreen());
                                    break;
                                  case 2:
                                    Get.to(()=>MessagesScreen());
                                    break;
                                  default:

                                }
                              },
                              leading: Image.asset(profileButtonsIcon[index],width: 22,),
                              title: profileButtonsList[index].text.fontFamily(semibold).color(darkFontGrey).make(),
                            );
                          }
                      ).box.shadowSm.rounded.margin(EdgeInsets.all(12)).white.padding(EdgeInsets.symmetric(horizontal: 16)).make().box.color(Colors.red).make(),
                    ],
                  ).box.make(),
                );
              }

            }
        )
      ),
    );
  }
}
