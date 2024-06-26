import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicplayer/database/Db%20model/playlistmodel.dart';
import 'package:musicplayer/database/Db_function/favdb_function.dart';
import 'package:musicplayer/view/screen/cataogry/song_list.dart';
import 'package:musicplayer/view/screen/splash_screenimage.dart';
import 'package:musicplayer/view/widgets/cmmn_background_color.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
       FocusManager.instance.primaryFocus?.unfocus();
    });
    return CmnBgdClor(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        //  ListTile(
                        //   onTap: (() {
                        //      Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (ctx) => const ScanScreen()));
                  
                              
                        //     }),
                          
                        //     leading: settingstext('Scan App'),
                        //     trailing: IconButton(
                        //         onPressed: () {
                        //           Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (ctx) => const ScanScreen(),
                        //       ),
                        //     );
                                   
                        //         },  icon: const Icon(Icons.restart_alt_sharp))),
                        
                        ListTile(
                          onTap: (() {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const SongListScreen(),
                              ),
                            );
                          }),
                          leading: settingstext('Library'),
                          trailing: IconButton(
                            icon: const Icon(Icons.library_music),
                            onPressed: () {
                               Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const SongListScreen(),
                              ),
                            );
                            },
                          ),
                        ),
                        
                        ListTile(
                          onTap: (() {
                             _email();
                          }),
                          leading: settingstext('Feedback'),
                          trailing: IconButton(
                              onPressed: () {
                             _email();
                              },
                              icon: const Icon(Icons.feedback)),
                        ),
                        ListTile(
                            onTap: (() {
                              _about();
                            }),
                            leading: settingstext('About Developer'),
                            trailing: IconButton(
                                onPressed: () {
                                  _about();
                                },
                                icon: const Icon(Icons.laptop))),
                        ListTile(
                            onTap: (() {
                              _shareapp();
                            }),
                            leading: settingstext('Share App'),
                            trailing: IconButton(
                                onPressed: () {
                                  _shareapp();
                                }, icon: const Icon(Icons.share))),
                        ListTile(
                          onTap: (() {
                  
                              resetapplication(context);
                            }),
                          
                            leading: settingstext('Reset App'),
                            trailing: IconButton(
                                onPressed: () {
                                   resetapplication(context);
                                },  icon: const Icon(Icons.restart_alt_sharp))),
                        
                        
                      ],
                    ),
                  ),
                  const Text('Version 1.0.0',style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold) ,)
                
                ],
              ),
            ),
          )),
    );
  }




  Widget settingstext(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
        );
  }
  
  Future<void> _about() async {
    // ignore: deprecated_member_use
    if (await launch('https://shellhacker.github.io/Personal-Webpage/')) {
      throw "Try Again";
    }
  }

  Future<void> _email() async {
    // ignore: deprecated_member_use
    if (await launch('mailto:shabanaspb@gmail.com')) {
      throw "Try Again";
    }
  }

  Future<void> _shareapp() async {
    const applink = 'https://play.google.com/store/apps/details?id=com.fouvty.Tunezx';
    await Share.share(applink);
  }


resetapplication(context) {
    showDialog(
        context: context,
        builder: (i) {
          return AlertDialog(
            title: const Text('Are you Sure ?'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {
                    Navigator.of(context).pop();

                  }, style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 30, 31, 70),
                  ), child: const Text('NO'),),
                  ElevatedButton(
                      onPressed: () {
                        
                        appreset(context);
                         
                      },
                      
                       style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 30, 31, 70),
                  ),
                      child: const Text('YES'),)
                      ,
                ],
              )
            ],
          );
        });
  }


  Future<void> appreset(context) async {

    final playlistDB = Hive.box<PlaylistDbmodel>('PlayListDB');
    final musicDb = Hive.box<int>('favoriteDB');
    await playlistDB.clear();
    await musicDb.clear();
    context.read<FavoriteDB>().favoriteSongs.clear();
 
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) =>  const SplashScreenImage(),
        ),
        (route) => false);
  }



}
