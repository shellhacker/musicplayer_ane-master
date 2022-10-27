import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/database/Db%20model/playlistmodel.dart';
import 'package:musicplayer/database/Db_function/playlist_db_folder_function.dart';
import 'package:musicplayer/view/screen/playlist_screens/playlist_allsong_screen.dart';
import 'package:musicplayer/view/screen/playnow_screen.dart';
import 'package:musicplayer/view/widgets/cmmn_background_color.dart';
import 'package:musicplayer/view/widgets/song_storage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PlaylistData extends StatelessWidget {
  PlaylistData({Key? key, required this.playlist, required this.folderindex})
      : super(key: key);
  final PlaylistDbmodel playlist;
  final int folderindex;

  final AudioPlayer audioPlayer = AudioPlayer();
  late List<SongModel> playlistsong;
  @override
  Widget build(BuildContext context) {
    return CmnBgdClor(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back)),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(playlist.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) =>
                          (PlaylistAllSongsScreen(playlist: playlist))));
                },
                icon: const Icon(Icons.playlist_add))
          ],
        ),
        body:
            // playlist.playlistDB.values.isEmpty? Center(child: Text('Add Songs'),)
            // :
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: SafeArea(
                child: Column(
              children: [
                Consumer<PlaylistController>(
                  builder: (context, value, child) {
                    Hive.box<PlaylistDbmodel>('playlistDB').listenable();
                    playlistsong = listPlaylist(value.playlistNotofier.toList()[folderindex].songid);
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (ctx, index) {
                          return ListTile(
                            leading: QueryArtworkWidget(
                              id: playlistsong[index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Icon(
                                Icons.music_note,
                              ),
                              errorBuilder: (context, excepion, gdb) {
                                return const Text('');
                              },
                            ),
                            title: Text(
                              playlistsong[index].title,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                            subtitle: Text(
                              playlistsong[index].artist!,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 253, 252, 252)),
                            ),
                            trailing: PopupMenuButton(
                                color: Colors.transparent,
                                elevation: 0,
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.black),
                                            onPressed: () {
                                              playlist.deleteData(
                                                  playlistsong[index].id);
                                            },
                                            child: const Text(
                                                'Remove From Playlist')),
                                      ),
                                    ]),
                            onTap: () {
                              List<SongModel> newlist = [...playlistsong];
                              Songstorage.player.stop();
                              Songstorage.player.setAudioSource(
                                  Songstorage.createSongList(newlist),
                                  initialIndex: index);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => PlayNowScreen(
                                      songModel: Songstorage.playingSongs)));
                            },
                          );
                        },
                        separatorBuilder: (ctx, index) {
                          return const Divider();
                        },
                        itemCount: playlistsong.length);
                  },
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < Songstorage.songCopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (Songstorage.songCopy[i].id == data[j]) {
          plsongs.add(Songstorage.songCopy[i]);
        }
      }
    }
    return plsongs;
  }
}
