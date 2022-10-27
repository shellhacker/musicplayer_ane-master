import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/controller/playlist_adding_button.dart';
import 'package:musicplayer/database/Db%20model/playlistmodel.dart';
import 'package:musicplayer/database/Db_function/playlist_db_folder_function.dart';
import 'package:musicplayer/view/widgets/cmmn_background_color.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlaylistAllSongsScreen extends StatelessWidget {
  static List<SongModel> allSongs = [];
  PlaylistAllSongsScreen({Key? key, required this.playlist}) : super(key: key);
  final PlaylistDbmodel playlist;

  final _audioQuery = OnAudioQuery();
  static final _audioPlayer = AudioPlayer();

  playsong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log('Song Parsing is Error');
    }
  }

  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PlaylistController>(context,listen: false);
     // ignore: unused_local_variable
     var providerplayicon = Provider.of<PlylistAddingButton>(context,listen: false);
    return CmnBgdClor(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(playlist.name),
          ),
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
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                          itemCount: item.data!.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                                height: 5,
                                thickness: 2,
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
                              title: Text(
                                item.data![index].displayNameWOExt,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: const Text('artist name'),
                              trailing: Consumer<PlylistAddingButton>(builder: (context, value, child) => 
                                IconButton(
                                  icon: !playlist.isValueIn(item.data![index].id)
                                      ? const Icon(
                                          Icons.add_circle_outline,
                                        )
                                      : const Icon(Icons.close_rounded),
                                  color: !playlist.isValueIn(item.data![index].id)
                                      ? Colors.white
                                      : Colors.red,
                                  onPressed: () {
                                 context.read< PlylistAddingButton>().playlistButtonColorChange(Colors.red);
                              
                                    playlistCheck(item.data![index], context);
                                    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                                    provider.notifyListeners();
                                  },
                                ),
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

  void playlistCheck(SongModel data, context) {
    if (!playlist.isValueIn(data.id)) {
      playlist.add(data.id);
      const snackbar = SnackBar(
        backgroundColor: Color.fromARGB(255, 247, 210, 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        content: Text(
          'Added to Playlist',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      playlist.deleteData(data.id);
      const snackbar = SnackBar(
        backgroundColor: Color.fromARGB(255, 247, 210, 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        content: Text(
          'Song Removed From Playlist',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
