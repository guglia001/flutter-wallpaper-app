import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaper_dope/src/bloc/db_bloc.dart';
import 'package:wallpaper_dope/src/localizations.dart';
import 'package:wallpaper_dope/src/models/db_model.dart';

class SavedPage extends StatefulWidget {
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final dbBloc = new DBbloc();

  @override
  Widget build(BuildContext context) {
    dbBloc.obtenerFotosGuardadas();
    return  StreamBuilder<List<DBModel>>(
        stream: dbBloc.dbStrem,
        builder: (context, AsyncSnapshot<List<DBModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ThemeData.dark().colorScheme.primary)));
          }
          final scans = snapshot.data;

          if (scans.length == 0) {
            return Center(
              child: Text(AppLocalizations.of(context).translate('dbmain'), style: GoogleFonts.ptSans(
                color: Colors.black.withOpacity(0.4),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),),
            );
          }
          return GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              mainAxisSpacing: 2,
                crossAxisCount: 3),
            itemCount: scans.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                              child: Image(
                  image: NetworkImage(scans[index].image),
                ),
              );
            },
          );
        },
      );
    
  }
}
