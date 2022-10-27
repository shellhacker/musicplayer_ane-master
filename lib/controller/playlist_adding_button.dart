import 'package:flutter/cupertino.dart';

class PlylistAddingButton extends ChangeNotifier{

 Color playListButtonColor = const Color.fromARGB(255, 251, 247, 247);
  void playlistButtonColorChange(color){
    playListButtonColor=color;
    notifyListeners();
  }



}