
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_dope/src/pages/home_page.dart';
import 'package:wallpaper_dope/src/pages/uploads_page.dart';
import 'package:wallpaper_dope/src/pages/saved_page.dart';
import 'package:wallpaper_dope/src/pages/trending_page.dart';

class ControllerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final index = Provider.of<BottomNavigationBarProvider>(context);
    var currentTab = [
      TrendingPage(),
      UploadsPage(),
      HomePage(),
      SavedPage(),
    ];
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(children: <Widget>[
        background(size),
        currentTab[index.currentIndex],
        Align(alignment: Alignment.bottomCenter, child: BtnNavBar()),
      ]),
    );
  }

  background(Size size) {
    return Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
           color: ThemeData.dark().colorScheme.secondary));
  }
}

class BtnNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final index = Provider.of<BottomNavigationBarProvider>(context);

    return Container(
      child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(37),
            topLeft: Radius.circular(37),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              color: ThemeData.dark().colorScheme.primary.withOpacity(0.6),
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Feather.trending_up,
                            color: index.currentIndex == 0
                                ? ThemeData.dark().accentColor
                                : ThemeData.dark().bottomAppBarColor),
                        onPressed: () {
                          index.currentIndex = 0;
                        }),
                    IconButton(
                        iconSize: 28,
                        icon: Icon(Ionicons.ios_people,
                            color: index.currentIndex == 1
                                ? ThemeData.dark().accentColor
                                : ThemeData.dark().bottomAppBarColor),
                        onPressed: () {
                          index.currentIndex = 1;
                        }),
                    IconButton(
                        icon: Icon(
                          FontAwesome.photo,
                          color: index.currentIndex == 2
                              ? ThemeData.dark().accentColor
                              : ThemeData.dark().bottomAppBarColor,
                        ),
                        onPressed: () {
                          index.currentIndex = 2;
                        }),
                    IconButton(
                        icon: Icon(Feather.bookmark,
                            color: index.currentIndex == 3
                                ? ThemeData.dark().accentColor
                                : ThemeData.dark().bottomAppBarColor),
                        onPressed: () {
                          index.currentIndex = 3;
                        }),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
