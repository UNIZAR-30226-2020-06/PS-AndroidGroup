import 'package:beats/PlayerWidget.dart';
import 'package:beats/reproductorMusica.dart';
import 'package:beats/screens/Bookmarks.dart';
import 'package:beats/screens/PlaylistLibrary.dart';
import 'package:beats/screens/PodcastLibrary.dart';
import 'package:beats/screens/ProfileEdit.dart';
import 'package:beats/screens/UserProfile.dart';
import 'package:beats/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:expanding_bottom_bar/expanding_bottom_bar.dart';
import 'Directos.dart';
import 'HomeScreen.dart';
import 'Register.dart';
import 'Settings.dart';
import 'MusicLibrary.dart';
import 'Social.dart';
import 'UploadSong.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver{


  var index = 1;
  var screens = [PodcastLibrary(), Directos(), MusicLibrary(), PlaylistLibrary(), Social(), Bookmarks(), ProfilePage()]; //tenía añadido upload song

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
          body: screens[index],
          bottomNavigationBar: ExpandingBottomBar(
            animationDuration: Duration(milliseconds: 500),
            backgroundColor: Theme.of(context).backgroundColor,
              navBarHeight: 60,
              items: [
                ExpandingBottomBarItem(
                    icon: Icons.mic,
                    text: "Podcasts",
                    selectedColor: Colors.deepPurpleAccent),
                ExpandingBottomBarItem(
                    icon: Icons.radio,
                    text: "Directos",
                    selectedColor: Colors.red),
                ExpandingBottomBarItem(
                    icon: Icons.music_note,
                    text: "Canciones",
                    selectedColor: Colors.pinkAccent),
                ExpandingBottomBarItem(
                    icon: Icons.headset,
                    text: "Playlists",
                    selectedColor: Colors.pinkAccent),
                ExpandingBottomBarItem(
                    icon: Icons.person_add,
                    text: "Social",
                    selectedColor: Colors.pinkAccent),
               // ExpandingBottomBarItem(
               //     icon: Icons.backup,
               //     text: "Agregar",
               //     selectedColor: Colors.orange),
                ExpandingBottomBarItem(
                    icon: Icons.star_border,
                    text: "Favoritos",
                    selectedColor: Colors.red),
                ExpandingBottomBarItem(
                    icon: Icons.supervised_user_circle,
                    text: "Perfil",
                    selectedColor: Colors.orange),
              ],
              selectedIndex: index,
              onIndexChanged: (i) {
                setState(() {
                  index = i;
                });


              })
    );
  }
}
