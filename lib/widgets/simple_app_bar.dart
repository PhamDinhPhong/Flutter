import 'package:demo/global/global.dart';
import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  String? title;
  final PreferredSizeWidget? bottom;

  SimpleAppBar({this.bottom, this.title});

  @override
  Size get preferredSize => bottom == null? Size(56, AppBar().preferredSize.height) : Size(56, 80 + AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: foodbloodcolor,
      centerTitle: true,
      title: Text(
        title! + "s items",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
