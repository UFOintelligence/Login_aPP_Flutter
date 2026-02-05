import'package:flutter/material.dart';
import 'package:curso1/core/network/api_exception.dart';


class SnackbarHelper {
  static void show(BuildContext context, ApiException error){

    Color backgroundColor = Colors.red;
    Duration duration = const Duration(seconds: 3);

    switch (error.statusCode){
      case 401:
      backgroundColor = Colors.redAccent;
      break;
      case 422:
      backgroundColor = Colors.orange;
      break;
      case 500:
      backgroundColor = Colors.black87;
      duration = const Duration(seconds: 4);
      break;
      default:
      backgroundColor = Colors.red;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: 
      Text(error.message),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      ),
    );
  }

}