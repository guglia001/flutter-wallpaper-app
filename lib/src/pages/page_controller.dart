import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_admob/firebase_admob.dart';
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
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-4476745438283982~6573880191");

     _showAd() {
      MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
        childDirected: false,
        testDevices: <String>["6C081232C5994B872D0BAE577176788A"],
      );

      final _interestialAD = InterstitialAd(
        adUnitId: 'ca-app-pub-4476745438283982/7883445056',
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("InterstitialAd event is $event");
        },
      );
     return _interestialAD
        ..load()
        ..show(
          anchorType: AnchorType.bottom,
          anchorOffset: 0.0,
          horizontalCenterOffset: 0.0,
        );
    }
    Timer.periodic(Duration(seconds: 200), (timer) {_showAd();});


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
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
             colors:[
              Color(0xFF6A040F),
              Color(0xFF370617),
              Color(0xFF03071E),
            ])));
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
              color: Color(0xff9D0208).withOpacity(0.6),
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Feather.trending_up,
                            color: index.currentIndex == 0
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black),
                        onPressed: () {
                          index.currentIndex = 0;
                        }),
                    IconButton(
                        iconSize: 28,
                        icon: Icon(Ionicons.ios_people,
                            color: index.currentIndex == 1
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black),
                        onPressed: () {
                          index.currentIndex = 1;
                        }),
                    IconButton(
                        icon: Icon(
                          FontAwesome.photo,
                          color: index.currentIndex == 2
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black,
                        ),
                        onPressed: () {
                          index.currentIndex = 2;
                        }),
                    IconButton(
                        icon: Icon(Feather.bookmark,
                            color: index.currentIndex == 3
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black),
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
