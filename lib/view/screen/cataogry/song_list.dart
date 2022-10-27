import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/controller/fav_botton.dart';
import 'package:musicplayer/database/Db_function/favdb_function.dart';
import 'package:musicplayer/view/screen/playnow_screen.dart';
import 'package:musicplayer/view/widgets/cmmn_background_color.dart';
import 'package:musicplayer/view/widgets/song_storage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SongListScreen extends StatelessWidget {
  static List<SongModel> allSongs = [];
  const SongListScreen({Key? key}) : super(key: key);

  static final _audioQuery = OnAudioQuery();
  static final _audioPlayer = AudioPlayer();

  playsong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log('Song Parsing is Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      FocusManager.instance.primaryFocus?.unfocus();
      await Permission.storage.request();
    });

    return CmnBgdClor(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<SongModel>>(
                  future: _audioQuery.querySongs(
                      sortType: null,
                      orderType: OrderType.ASC_OR_SMALLER,
                      uriType: UriType.EXTERNAL,
                      ignoreCase: true),
                  builder: (context, item) {
                    if (item.data == null) {
                      return const Center(
                        child: Text(''),
                      );
                    }
                    if (item.data!.isEmpty) {
                      return const Center(
                          child: Text(
                        'No Songs Found',
                        style: TextStyle(fontSize: 20),
                      ));
                    }

                    SongListScreen.allSongs = item.data!;

                    if (!context.read<FavoriteDB>().isInitialized) {
                      context.read<FavoriteDB>().initialise(item.data!);
                    }
                    Songstorage.songCopy = item.data!;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                          itemCount: item.data!.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                                height: 15,
                                thickness: 10,
                              ),
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: ClipRRect(
                                child: QueryArtworkWidget(
                                    id: item.data![index].id,
                                    type: ArtworkType.AUDIO,
                                    artworkFit: BoxFit.cover,
                                    nullArtworkWidget:
                                        const Icon(Icons.music_note)),
                              ),
                              onTap: () {
                                Songstorage.player.setAudioSource(
                                    Songstorage.createSongList(item.data!),
                                    initialIndex: index);
                                Songstorage.player.play();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PlayNowScreen(songModel: item.data!)),
                                );
                              },
                              title: Text(
                                item.data![index].displayNameWOExt,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                item.data![index].album!,
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Consumer<FavoriteButton>(
                                builder: (context, value, _) {
                                  return FavIconColorChanging(
                                      allSongs: allSongs,
                                      value: value,
                                      index: index,
                                      context: context);
                                },
                              ),
                            );
                          }),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}

class FavIconColorChanging extends StatelessWidget {
  const FavIconColorChanging({
    Key? key,
    required this.allSongs,
    required this.value,
    required this.index,
    required this.context,
  }) : super(key: key);

  final List<SongModel> allSongs;
  final FavoriteButton value;
  final int index;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          value.favButtonColorChange(Colors.red);
          if (FavoriteDB.isfavor(allSongs[index])) {
            context.read<FavoriteDB>().delete(allSongs[index].id);
            const snackBar = SnackBar(
                backgroundColor: Color.fromARGB(255, 247, 210, 2),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(8),
                content: Text(
                  'Removed From Heart',
                  style: TextStyle(color: Color.fromARGB(255, 247, 247, 247)),
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            context.read<FavoriteDB>().add(allSongs[index]);

            const snackbar = SnackBar(
              margin: EdgeInsets.all(8),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color.fromARGB(255, 247, 210, 2),
              content: Text(
                'Song Added to Favorite',
                style: TextStyle(color: Colors.white),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        },
        icon: FavoriteDB.isfavor(allSongs[index])
            ? Icon(
                Icons.favorite,
                color: value.favButtonColor,
              )
            : const Icon(Icons.favorite_border,
                color: Color.fromARGB(255, 185, 183, 183)));
  }
}
