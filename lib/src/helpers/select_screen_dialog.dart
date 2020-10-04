import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_dope/src/providers/uploads_provider.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

import '../localizations.dart';

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
                    await WallpaperManager.setWallpaperFromFile(path, location)
                        .whenComplete(() {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      provider.loading = false;
                      provider.loadingMain = false;
                    });
                  },
                ),
              ],
            ),
          ],
        );
  final alert = alertDialog;

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
