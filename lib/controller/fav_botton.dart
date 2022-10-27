import 'package:flutter/material.dart';

class FavoriteButton with ChangeNotifier{

  Color favButtonColor = const Color.fromARGB(255, 239, 6, 6);
  void favButtonColorChange(color){
    favButtonColor=color;
    notifyListeners();
  }





}