import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/global/global.dart';
import 'package:demo/models/items.dart';
import 'package:demo/splashScreen/splash_sreen.dart';
import 'package:demo/widgets/simple_app_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ItemsDetailsScreen extends StatefulWidget {
  final Items? model;
  ItemsDetailsScreen({this.model});

  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();
}

class _ItemsDetailsScreenState extends State<ItemsDetailsScreen> {

  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String itemID) {
    FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid")).collection("menus")
        .doc(widget.model!.menuID).collection("items").doc(itemID).delete().then((value)
    {

          FirebaseFirestore.instance.collection("items").doc(itemID).delete();

          Navigator.push(context, MaterialPageRoute(builder: (c)=> SplashSreen()));
          Fluttertoast.showToast(msg: "Item Deleted Succesfully.");
    });
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: sharedPreferences!.getString("name"),),
      body: Column(
        children: [
            Image.network(widget.model!.thumbnailUrl.toString(),),
          
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.model!.title.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20,
                        ),
                      ),

                      Text(
                        "TK " + widget.model!.price.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20,
                        ),
                      )
                    ],
                  ),

                  Text(
                    widget.model!.longDescription.toString(),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(height: 15,),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        deleteItem(widget.model!.itemID!);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: foodbloodcolor,
                        ),
                        width: MediaQuery.of(context).size.width - 13,
                        height: 50,
                        child: Center(
                          child: Text(
                            "Delete This Items",
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold,),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
