import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/database/Db_function/favdb_function.dart';
import 'package:musicplayer/view/screen/playnow_screen.dart';
import 'package:musicplayer/view/widgets/cmmn_background_color.dart';
import 'package:musicplayer/view/widgets/song_storage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavListScreen extends StatelessWidget {
  final AudioPlayer audioPlayer = AudioPlayer();
  final OnAudioQuery audioQuery = OnAudioQuery();

  FavListScreen({Key? key}) : super(key: key);

  // ignore: unused_element
  static ConcatenatingAudioSource createSongList(List<SongModel> song) {
    List<AudioSource> source = [];
    for (var songs in song) {
      source.add(AudioSource.uri(Uri.parse(songs.uri!)));
    }
    return ConcatenatingAudioSource(children: source);
  }

  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    
    return Consumer<FavoriteDB>(
        builder: (BuildContext ctx, value, Widget? child) {
      return CmnBgdClor(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: value.favoriteSongs.isEmpty
                ? const Center(
                    child: Text(
                      'No Song Found',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<FavoriteDB>(
                      builder: (BuildContext ctx, favorData, Widget? child) {
                        return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (ctx, index) {
                              return ListTile(
                                onTap: () {
                                  List<SongModel> newlist = [
                                    ...favorData.favoriteSongs
                                  ];
                                  Songstorage.player.pause();

                                  Songstorage.player.setAudioSource(
                                      Songstorage.createSongList(newlist),
                                      initialIndex: index);
                                  Songstorage.player.play();

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => PlayNowScreen(
                                            songModel: favorData.favoriteSongs,
                                          )));
                                },
                                leading: QueryArtworkWidget(
                                  id: favorData.favoriteSongs[index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget:
                                      const Icon(Icons.music_note_outlined),
                                ),
                                title: Text(
                                  favorData.favoriteSongs[index].title,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                subtitle: Text(
                                  favorData.favoriteSongs[index].artist!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    context.read<FavoriteDB>().delete(
                                        favorData.favoriteSongs[index].id);
                                    const snackBar = SnackBar(
                                        backgroundColor:
                                            Color.fromARGB(255, 247, 210, 2),
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.all(8),
                                        content: Text(
                                          'Removed From Heart',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 247, 247, 247)),
                                        ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  icon: const Icon(Icons.delete_forever),
                                  color: const Color.fromARGB(255, 203, 16, 3),
                                ),
                              );
                            },
                            separatorBuilder: (ctx, index) {
                              return const Divider(
                                height: 15,
                                thickness: 10,
                              );
                            },
                            itemCount: favorData.favoriteSongs.length);
                      },
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
