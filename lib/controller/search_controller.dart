import 'package:flutter/cupertino.dart';
import 'package:musicplayer/view/screen/cataogry/song_list.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchController with ChangeNotifier{
  List<SongModel>tempSongs= SongListScreen.allSongs;
   searchSong(String query) {

    
    final suggestions = SongListScreen.allSongs.where((song) {
      final songTitel = song.title.toLowerCase();
      final input = query.toLowerCase(); 

      return songTitel.contains(input);
    }).toList();
    
      tempSongs = suggestions;
   
  }

}