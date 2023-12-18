import 'package:demo/authentication/login.dart';
import 'package:demo/global/global.dart';
import 'package:flutter/material.dart';
import '../mainScreen/home_screen.dart';
import '../models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  Users? model;
  BuildContext? context;
  Future<String?> getPhotoUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? photoUrl = sharedPreferences.getString("photoUrl");
    return photoUrl;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder (
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
        return Drawer(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(top: 25, bottom: 10),
                decoration: BoxDecoration(
                  color: foodbloodcolor,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                      ),
                      // child: Padding(
                      //   padding: EdgeInsets.all(1),
                      //   child: Container(
                      //     height: 100,
                      //     width: 100,
                      //     child: CircleAvatar(
                      //       backgroundImage: NetworkImage(
                      //           sharedPreferences!.getString("photourl")!,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      child: Padding(
                        padding: EdgeInsets.all(1),
                        child: Container(
                          width: 100,
                          height: 100,
                          child: FutureBuilder<String?>(
                            future: getPhotoUrl(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(sharedPreferences!.getString("photoUrl")!),
                                );
                              } else {
                                return Placeholder(); // Placeholder while loading or handle differently
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10,),

                    Text(
                      sharedPreferences!.getString("name")!,
                      // widget.model!.userName!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ),

              SizedBox(height: 12,),

              Container(
                padding: EdgeInsets.only(top: 1),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.home, color: foodbloodcolor,),
                      title: Text("Home",
                      style: TextStyle(color: Colors.black,),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.reorder, color: foodbloodcolor,),
                      title: Text("My Order",
                        style: TextStyle(color: Colors.black,),
                      ),
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.access_time, color: foodbloodcolor,),
                      title: Text("History",
                        style: TextStyle(color: Colors.black,),
                      ),
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.exit_to_app, color: foodbloodcolor,),
                      title: Text("Sign Out",
                        style: TextStyle(color: Colors.black,),
                      ),
                      onTap: () {
                        firebaseAuth.signOut().then((value) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (c) => LoginScreen()));
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}



