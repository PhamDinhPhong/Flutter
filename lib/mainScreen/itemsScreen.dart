import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/widgets/app_bar.dart';
import 'package:demo/widgets/items_design.dart';
import 'package:demo/widgets/progress_bar.dart';
import 'package:demo/widgets/text_widget_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:demo/global/global.dart';
import '../models/menus.dart';
import '../models/items.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;
  ItemsScreen({this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        sellerUID: widget.model!.sellerUID,
      ),
      body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(
                  title: "Items of " + widget.model!.menuTitle.toString(),),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("sellers")
                    .doc(widget.model!.sellerUID)
                    .collection("menus")
                    .doc(widget.model!.menuID)
                    .collection("items")
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                  ? SliverToBoxAdapter(
                    child: Center(child: circularProgress(),),
                  ) :
                  SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 2,
                          staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                          itemBuilder: (context, index) {
                            Items itemsModel = Items.fromJson(
                                snapshot.data!.docs[index].data()! as Map<String, dynamic>
                            );
                            return ItemsDesignWidget(
                              model: itemsModel,
                              context: context,
                            );
                          },
                          itemCount: snapshot.data!.docs.length,
                        );
                })
      ]),
    );
  }
}
