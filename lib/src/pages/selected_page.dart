import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper_dope/src/bloc/db_bloc.dart';
import 'package:wallpaper_dope/src/helpers/select_screen_dialog.dart';
import 'package:wallpaper_dope/src/localizations.dart';
import 'package:wallpaper_dope/src/models/db_model.dart';

import 'package:wallpaper_dope/src/providers/uploads_provider.dart';
import 'package:wallpaper_dope/src/widgets/like_button.dart';

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
    final size = MediaQuery.of(context).size;

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
                              color: ThemeData.dark().colorScheme.secondary)),
                      Center(
                          child: Container(
                        height: 150,
                        width: 150,
                        child: LiquidCircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                          valueColor: AlwaysStoppedAnimation(ThemeData.dark().colorScheme.secondary),
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
                        btnRetrocederPantallla(context),
                        //Guardar
                        RawMaterialButton(
                          onPressed: () async {
                            provider.loadingMain = true;
                            Random random = new Random();
                            Directory directorio =
                                await getApplicationDocumentsDirectory();
                            var randid = random.nextInt(10000);
                            final path = join(
                                directorio.path + randid.toString() + ".jpg");
                            Dio dio = new Dio();
                            await dio.download(image, path);
                            showAlertDialog(context, path);
                            provider.loadingMain = false;
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
                        btnGuardarBD()
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  btnRetrocederPantallla(BuildContext context) {
    return RawMaterialButton(
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
        });
  }

  btnGuardarBD() {
    return RawMaterialButton(
      fillColor: Colors.black.withOpacity(0.6),
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
      elevation: 2.0,
      onPressed: () {
        final dbBloc = new DBbloc();
        final db = DBModel(image: image, lowResImage: lowResImage);
        dbBloc.agregarFoto(db);
      },
      child: Icon(
        Feather.bookmark,
        color: Colors.white,
      ),
    );
  }
}
