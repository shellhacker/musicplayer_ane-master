import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteDB with ChangeNotifier {
   bool isInitialized = false;
  static final musicDb = Hive.box<int>('favoriteDB');
   List<SongModel>favoriteSongs =[];
 initialise(List<SongModel> songs) {
    for (SongModel song in songs) {
      if (isfavor(song)) {
        favoriteSongs.add(song);
        notifyListeners();
      }
      
    }
    isInitialized = true;
  }

  add(SongModel song) async {
    musicDb.add(song.id);
    favoriteSongs.add(song);
    notifyListeners();
  
  }

   delete(int id) async {
    int deletekey = 0;
    if (!musicDb.values.contains(id)) {
      return;
      
    }
    final Map<dynamic, int> favorMap = musicDb.toMap();
    favorMap.forEach((key, value) {
      if (value == id) {
        deletekey = key;
      }
    });
    musicDb.delete(deletekey);
    favoriteSongs.removeWhere((song) => song.id == id);
    notifyListeners();
  }

  static bool isfavor(SongModel song) {
    if (musicDb.values.contains(song.id)) {
      
      return true;
    
    }

    return false;
  }
  
}
