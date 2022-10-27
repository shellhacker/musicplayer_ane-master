import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/controller/fav_botton.dart';
import 'package:musicplayer/controller/playlist_adding_button.dart';
import 'package:musicplayer/controller/playnow_conroller.dart';
import 'package:musicplayer/controller/refresh_notifier.dart';
import 'package:musicplayer/controller/search_controller.dart';
import 'package:musicplayer/database/Db%20model/playlistmodel.dart';
import 'package:musicplayer/database/Db_function/favdb_function.dart';
import 'package:musicplayer/database/Db_function/playlist_db_folder_function.dart';
import 'package:musicplayer/view/screen/splash_screenimage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(PlaylistDbmodelAdapter().typeId)) {
    Hive.registerAdapter(PlaylistDbmodelAdapter());
  }
  await Hive.openBox<int>('favoriteDB');
  await Hive.openBox<PlaylistDbmodel>('PlayListDB');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoriteDB>(create: (_) => FavoriteDB()),
        ChangeNotifierProvider<FavoriteButton>(create: (_) => FavoriteButton()),
        ChangeNotifierProvider<PlaylistController>(
            create: (_) => PlaylistController()),
        ChangeNotifierProvider<RefreshNotifier>(
            create: (_) => RefreshNotifier()),
        ChangeNotifierProvider<SearchController>(
            create: (_) => SearchController()),
        ChangeNotifierProvider<PlylistAddingButton>(
            create: (_) => PlylistAddingButton()),
        ChangeNotifierProvider<PlayNowController>(
            create: (_) => PlayNowController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: const Color.fromARGB(255, 213, 143, 255),
            secondaryHeaderColor: const Color.fromARGB(255, 30, 4, 47),
            tabBarTheme: const TabBarTheme()),
        home: const SplashScreenImage(),
      ),
    );
  }
}
