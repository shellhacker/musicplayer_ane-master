
import 'package:flutter/cupertino.dart';
import 'package:musicplayer/view/widgets/song_storage.dart';

class PlayNowController extends ChangeNotifier{


int currentIndex = 0;
ss(){
   // ignore: unused_local_variable
   
    Songstorage.player.currentIndexStream.listen((index) {
      if (index != null) {
       
          currentIndex = index;
           notifyListeners();
          
      
        Songstorage.currentIndexx = index;
        notifyListeners();
      }
    });
} 
   
}
