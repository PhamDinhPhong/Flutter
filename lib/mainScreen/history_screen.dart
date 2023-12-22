import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/global/global.dart';
import 'package:demo/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/simple_app_bar.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "New Orders",),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(sharedPreferences!.getString("uid"))
            .collection("orders").where("status", isEqualTo: "ended").orderBy("orderTime", descending: true).snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                    future: FirebaseFirestore.instance
                      .collection("items")
                      .where("itemID", whereIn: separateOrderItemsIDs((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIDs"]))
                      .where("orderBy", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
                      .orderBy("publishedDate", descending: true).get(),
                    builder: (context, snap) {
                      return snap.hasData
                          ? Column(
                        children: [
                          OrderCard(
                            itemCount: snap.data!.docs.length,
                            data: snap.data!.docs,
                            orderId: snapshot.data!.docs[index].id,
                            separateQuantitiesList: separateOrderItemQuantities((snapshot.data!.docs[index].data()! as Map<String, dynamic>))
                          ),
                          Container(
                            height: 40,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: foodbloodcolor,
                            ),
                            child: Center(
                              child: Text("Click to see details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                          : Center(child: circularProgress(),
                      );
                });
              }) : Center(child: circularProgress(),
          );
        },
      ),
    );
  }
}
