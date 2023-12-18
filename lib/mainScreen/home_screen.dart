import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/global/global.dart';
import 'package:demo/models/sellers.dart';
import 'package:demo/splashScreen/splash_sreen.dart';
import 'package:demo/widgets/my_drawer.dart';
import 'package:demo/widgets/progress_bar.dart';
import 'package:demo/widgets/selllers_design.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: foodbloodcolor,
        title: Text("Food Blood",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Row(
            children: [
              IconButton(onPressed: () {},
                  icon: Icon(FontAwesomeIcons.locationArrow)),
              IconButton(onPressed: () {},
                  icon: Icon(FontAwesomeIcons.magnifyingGlass)),
            ],
            
          )
        ],
      ),

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: ImageSlideshow(
                autoPlayInterval: 5000,
                isLoop: true,
                indicatorColor: foodbloodcolor,
                indicatorBackgroundColor: Colors.white,
                indicatorRadius: 5,
                height: MediaQuery.of(context).size.height * 0.3,
                children: [
                  Image.asset("images/food1.jpg",
                    fit: BoxFit.cover,
                  ),

                  Image.asset("images/food2.jpg",
                    fit: BoxFit.cover,
                  ),

                  Image.asset("images/food3.jpg",
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Restaurants :",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("sellers").snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData ?
                    SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    ) :
                    SliverToBoxAdapter(
                      child: SizedBox(
                        width: 412,
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Sellers sModel = Sellers.fromJson(
                              snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                            );
                            return SellersDesignWidget(
                              model: sModel,
                              context: context,
                            );
                          },
                        ),
                      ),

                    );
              }
          )
        ],
      ),
      
      
    );
  }
}
