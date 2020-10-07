import 'dart:math';

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_dope/src/models/uploads_model.dart';
import 'package:wallpaper_dope/src/providers/uploads_provider.dart';

class UploadForm extends StatelessWidget {
  getDate() {
    String date = DateTime.now().toString();
    DateTime parse = DateTime.parse(date);
    return "${parse.year}-${parse.month}-${parse.day}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploadsProvider>(context);
    final size = MediaQuery.of(context).size;
    TextEditingController _author = TextEditingController();
    TextEditingController _instagram = TextEditingController();
    TextEditingController _date = TextEditingController();
    _date.text = getDate();

    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: 700,
              width: size.width,
              decoration:
                  BoxDecoration(color: ThemeData.dark().colorScheme.primary)),
          Theme(
            data: ThemeData(
                primaryColor: Colors.black, primaryColorDark: Colors.black),
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        iconSize: 32,
                        icon: Icon(
                          Ionicons.ios_close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Upload Wallpaper",
                    style: GoogleFonts.hind(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: InkWell(
                    onTap: () {
                      provider.selecionarImagen();
                    },
                    child: Container(
                      height: size.height * 0.2,
                      child: Image(
                        image: provider.imagenSeleccionada
                            ? FileImage(provider.imagenSeleecionadaFile)
                            : AssetImage('assets/no-image.png'),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _author,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black)),
                      fillColor: Colors.black,
                      hoverColor: Colors.black,
                      focusColor: Colors.black,
                      prefixIcon:
                          Icon(FontAwesome.user, size: 18, color: Colors.black),
                      labelStyle: GoogleFonts.ptSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      labelText: "Author:"),
                ),
                TextFormField(
                  controller: _instagram,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      prefixIcon: Icon(AntDesign.instagram,
                          size: 18, color: Colors.black),
                      labelStyle: GoogleFonts.ptSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      labelText: "Instagram:"),
                ),
                TextFormField(
                  controller: _date,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      enabled: false,
                      prefixIcon:
                          Icon(Entypo.calendar, size: 18, color: Colors.black),
                      labelStyle: GoogleFonts.ptSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      labelText: "Date:"),
                ),
                AnimatedIconButton(
                  size: 50,
                  tooltip: "Upload Wallpaper",
                  duration: Duration(milliseconds: 500),
                  startIcon: Icon(
                    MaterialCommunityIcons.cloud_upload,
                    color: Colors.black,
                  ),
                  endIcon: Icon(
                    MaterialIcons.cloud_done,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    await provider.subirImagen();
                    await provider.addNewWallpaper(UploadsModel(
                        img: provider.imgUrl,
                        activada: true,
                        fecha: _date.text,
                        instagram: _instagram.text,
                        user: _author.text,
                        likes: 0,
                        id: Random().nextInt(9999).toString()));

                    Future.delayed(Duration(seconds: 3))
                        .then((value) => Navigator.pop(context));
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
