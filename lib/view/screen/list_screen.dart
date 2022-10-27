import 'package:flutter/material.dart';
import 'package:musicplayer/view/screen/cataogry/add_to_playlist.dart';
import 'package:musicplayer/view/screen/cataogry/fav_screen.dart';
import 'package:musicplayer/view/screen/cataogry/search_screen.dart';
import 'package:musicplayer/view/screen/cataogry/settings_screen.dart';
import 'package:musicplayer/view/screen/cataogry/song_list.dart';

class ListScreen extends StatelessWidget {
   const ListScreen({Key? key}) : super(key: key);
   
 @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: const Color.fromARGB(255, 213, 143, 255),
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.music_note,
                  ),
                  text: 'Songs',
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                  text: 'Favourites',
                ),
                Tab(
                  icon: Icon(Icons.search),
                  text: 'Search',
                ),
                Tab(
                  icon: Icon(Icons.queue_music_sharp),
                  text: 'PlayList',
                ),
                Tab(
                  icon: Icon(Icons.settings_applications_sharp),
                  text: 'Settings',
                ),
              ],
              unselectedLabelColor: Colors.black,
              labelColor: Colors.white,
            ),
          ),
          body: TabBarView(children: [
            const SongListScreen(),
            FavListScreen(),
            const SearchScreen(),
            AddToPlaylist(),
             const SettingsScreen(),
          ]),

          // bottomNavigationBar: Consumer<RefreshNotifier>( builder: (BuildContext context,value,Widget) {
          //     return Songstorage.player.currentIndex != null?
          //         const MiniPlayerPage()
          //        :const SizedBox();
          //   }
        )

        //  bottomNavigationBar:Songstorage.player.currentIndex != null ? MiniPlayerPage(): SizedBox()

        );
  }
}
