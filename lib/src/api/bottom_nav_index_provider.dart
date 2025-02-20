import 'package:flutter/material.dart';

class Bottomnavindexprovider extends ChangeNotifier {
  int _bottomNavIndex=0;
  int get bottomNavIndex => _bottomNavIndex;

  void updateBottonNavIndex (int index){
    _bottomNavIndex =index;
    notifyListeners();
  }
  
}