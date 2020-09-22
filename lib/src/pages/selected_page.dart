import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper_dope/src/bloc/db_bloc.dart';
import 'package:wallpaper_dope/src/localizations.dart';
import 'package:wallpaper_dope/src/models/db_model.dart';

import 'package:wallpaper_dope/src/providers/uploads_provider.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class SelectedWallpaper extends StatelessWidget {
  final image;
  final lowResImage;
  final String instagram;
  final String user;
  final String date;
  final int likes;
  final documentId;
  final bool isFromUploadsPage;

  const SelectedWallpaper(
      {Key key,
      this.image,
      this.lowResImage,
      this.instagram,
      this.user,
      this.date,
      this.likes,
      this.documentId,
      this.isFromUploadsPage});

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-4476745438283982~6573880191");

    final size = MediaQuery.of(context).size;

    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      childDirected: false,
      testDevices: <String>[
        "6C081232C5994B872D0BAE577176788A"
      ], // Android emulators are considered test devices
    );

   final ad = RewardedVideoAd.instance
   ..load(
      adUnitId: "ca-app-pub-4476745438283982/6048100739",
      targetingInfo: targetingInfo,

    );

    final provider = Provider.of<UploadsProvider>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
              height: size.height,
              width: size.width,
              child: Image.network(
                image,
                fit: BoxFit.fitHeight,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Stack(
                    children: [
                      Container(
                          height: 700,
                          width: size.width,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomRight,
                                  colors: [
                                Color(0xFF6A040F),
                                Color(0xFF370617),
                                Color(0xFF03071E),
                              ]))),
                      Center(
                          child: Container(
                        height: 150,
                        width: 150,
                        child: LiquidCircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF6A040F)),
                          backgroundColor: Color(0xFF03071E),
                          borderColor: Color(0xFF006E),
                          borderWidth: 5.0,
                          direction: Axis.vertical,
                          center: Text(
                            AppLocalizations.of(context).translate('loading'),
                            style: GoogleFonts.ptSans(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )),
                    ],
                  );
                },
              )),
          isFromUploadsPage == true
              ? Positioned(
                  bottom: 100,
                  right: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // INSTAGRAM
                      InkWell(
                        onTap: () {
                          launch("https://www.instagram.com/$instagram/",
                              enableJavaScript: true);
                        },
                        child: Container(
                          width: 120,
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  AntDesign.instagram,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  instagram,
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 1,
                                          color: Colors.black,
                                          offset: Offset(0.0, 0.0),
                                        ),
                                      ],
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // LIKES
                      SizedBox(height: 10),
                      Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(15)),
                        child: LikeBoton(
                          likes: likes,
                          documentId: documentId,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          provider.loadingMain
              ? loading()
              : Positioned(
                  bottom: 10,
                  child: Container(
                    width: size.width,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Retroceder pantalla
                        RawMaterialButton(
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                            elevation: 2.0,
                            fillColor: Colors.black.withOpacity(0.6),
                            child: Icon(
                              Ionicons.ios_arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        //Guardar
                        RawMaterialButton(
                          onPressed: () async {
                            //TODO: aqioooooooo
                            provider.loadingMain = true;
                            ad.show().catchError((onError){print(onError);});
                            Random random = new Random();
                            Directory directorio =
                                await getApplicationDocumentsDirectory();
                            var randid = random.nextInt(10000);
                            final path = join(
                                directorio.path + randid.toString() + ".jpg");
                            Dio dio = new Dio();
                            await dio.download(image, path);
                            showAlertDialog(context, path);
                          },
                          child: Icon(
                            Entypo.download,
                            color: Colors.white,
                          ),
                          elevation: 2.0,
                          fillColor: Colors.black.withOpacity(0.6),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),

                        //Guardar BD
                        RawMaterialButton(
                          fillColor: Colors.black.withOpacity(0.6),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                          elevation: 2.0,
                          onPressed: () {
                            final dbBloc = new DBbloc();
                            final db =
                                DBModel(image: image, lowResImage: lowResImage);
                            dbBloc.agregarFoto(db);
                          },
                          child: Icon(
                            Feather.bookmark,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  loading() {
    return Align(
      alignment: Alignment.center,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(40)),
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String path) {
    // set up the button
    final provider = Provider.of<UploadsProvider>(context, listen: false);
    // set up the AlertDialog
    var alertDialog = provider.loading
        ? loading()
        : AlertDialog(
            actionsPadding: EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            backgroundColor: Colors.white,
            actions: [
              FlatButton(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Entypo.home, color: Colors.black87),
                    Text(AppLocalizations.of(context).translate("homescreen"),
                        style: TextStyle(color: Colors.black87)),
                  ],
                ),
                onPressed: () async {
                  provider.loading = true;
                  final location = WallpaperManager.HOME_SCREEN;
                  return await WallpaperManager.setWallpaperFromFile(
                          path, location)
                      .whenComplete(() {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    provider.loading = false;
                    provider.loadingMain = false;
                  });
                },
              ),
              FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(MaterialIcons.lock, color: Colors.black87),
                    Text(AppLocalizations.of(context).translate("lockscreen"),
                        style: TextStyle(color: Colors.black87)),
                  ],
                ),
                onPressed: () async {
                  provider.loading = true;
                  final location = WallpaperManager.LOCK_SCREEN;
                  return await WallpaperManager.setWallpaperFromFile(
                          path, location)
                      .whenComplete(() {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    provider.loading = false;
                    provider.loadingMain = false;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Entypo.home, color: Colors.black87),
                      Icon(MaterialIcons.lock, color: Colors.black87),
                    ],
                  ),
                  FlatButton(
                    child: Text(AppLocalizations.of(context).translate("both"),
                        style: TextStyle(color: Colors.black87)),
                    onPressed: () async {
                      provider.loading = true;
                      final location = WallpaperManager.BOTH_SCREENS;
                      await WallpaperManager.setWallpaperFromFile(
                              path, location)
                          .whenComplete(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        provider.loading = false;
                        provider.loadingMain = false;
                      });
                    },
                  ),
                ],
              ),
            ],
          );
    AlertDialog alert = alertDialog;

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class LikeBoton extends StatelessWidget {
  final likes;
  final documentId;

  const LikeBoton({Key key, this.likes, this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploadsProvider>(context);
    provider.likes = likes;

    return LikeButton(
        size: 28,
        circleColor: CircleColor(start: Colors.white, end: Colors.redAccent),
        bubblesColor: BubblesColor(
          dotPrimaryColor: Color(0xFF03071E),
          dotSecondaryColor: Color(0xff9D0208),
        ),
        onTap: provider.like(documentId),
        likeBuilder: (bool isLiked) {
          return Icon(
            AntDesign.heart,
            color: isLiked ? Colors.red : Colors.white,
            size: 28,
          );
        },
        likeCount: likes,
        countBuilder: (int count, bool isLiked, String text) {
          var color = isLiked ? Colors.red : Colors.white;
          Widget result;
          if (count == 0) {
            result = Text("   0",
                style: GoogleFonts.roboto(
                    color: color, fontSize: 12, fontWeight: FontWeight.bold));
          } else
            result = Text("   $text",
                style: GoogleFonts.roboto(
                    color: color, fontSize: 12, fontWeight: FontWeight.bold));
          return result;
        });
  }
}
