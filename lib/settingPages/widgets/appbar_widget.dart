import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    iconTheme: const IconThemeData(
        color: Colors
            .black), 
    leading: const BackButton(),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
