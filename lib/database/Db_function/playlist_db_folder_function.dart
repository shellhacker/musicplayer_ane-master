import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicplayer/database/Db%20model/playlistmodel.dart';

class PlaylistController with ChangeNotifier{



List<PlaylistDbmodel> playlistNotofier = [];


Future<void>addplaylist(PlaylistDbmodel value) async {
  final playlistDB =  Hive.box<PlaylistDbmodel>('PlayListDB');
await playlistDB.add(value);
   getplaylist();
   notifyListeners();
}

Future<void>getplaylist() async {
  final playlistDB = Hive.box<PlaylistDbmodel>('PlayListDB');
  playlistNotofier.clear();
  playlistNotofier.addAll(playlistDB.values);
  notifyListeners();


}

 Future<void>deletplaylist(index) async {
  final playlistDB =  Hive.box<PlaylistDbmodel>('PlayListDB');
  await playlistDB.deleteAt(index);
  getplaylist();
  notifyListeners();
}


  
}


