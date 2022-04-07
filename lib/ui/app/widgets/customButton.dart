import 'package:flutter/material.dart';


import '../const/AppColors.dart';

Widget customButton (String buttonText,onPressed){
  return SizedBox(
    width: 1,
    height: 56,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
            color: Colors.white, fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        primary: AppColors.deep_blue,
        elevation: 3,
      ),
    ),
  );
}