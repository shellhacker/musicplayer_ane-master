import 'package:flutter/material.dart';
import 'package:musicplayer/database/Db_function/favdb_function.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';


class FavoriteBut extends StatelessWidget {
   const FavoriteBut({Key? key, required this.song}) : super(key: key);
  final SongModel song;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        
      
        if (FavoriteDB.isfavor(song)) {
          context.read<FavoriteDB>().delete(song.id);
          const snackBar = SnackBar(backgroundColor: Color.fromARGB(255, 247, 210, 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(8),
              content: Text(
            'Removed From Heart',
            style: TextStyle(color: Color.fromARGB(255, 247, 247, 247)),
          ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        
        } else {
         context.read <FavoriteDB>().add(song);
          const snackbar = SnackBar(margin:EdgeInsets.all(8),
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
      icon: FavoriteDB.isfavor(song)
          ? const Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : const Icon(Icons.favorite_border,
              color: Color.fromARGB(255, 255, 255, 255)),
    );
  }
}