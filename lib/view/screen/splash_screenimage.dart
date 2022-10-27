import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/view/screen/list_screen.dart';
import 'package:musicplayer/view/widgets/cmmn_background_color.dart';

class SplashScreenImage extends StatelessWidget {
   const SplashScreenImage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
     return CmnBgdClor(
       child: Scaffold(
        backgroundColor: Colors.transparent,
         body: AnimatedSplashScreen(splash: 
           
           Image.asset('asset/splash .png',
           ),
           backgroundColor: Colors.transparent,
           splashIconSize: 300,
           
           
           duration: 4000,
           splashTransition: SplashTransition.slideTransition,
            //  pageTransitionType: PageTransitionType.,
         nextScreen:  const ListScreen()),
       ),
     );
 
  }
}
