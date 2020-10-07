import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_dope/src/models/uploads_model.dart';
import 'package:wallpaper_dope/src/pages/selected_page.dart';
import 'package:wallpaper_dope/src/pages/upload_form_page.dart';
import 'package:wallpaper_dope/src/providers/uploads_provider.dart';

class UploadsPage extends StatelessWidget {
  final firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final UploadsProvider provider = UploadsProvider();
    provider.getUploaded();

    return StreamProvider(
      create: (BuildContext context) => provider.getUploaded(),
      child: StreamBuilder(
        stream: firebase.asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded
                    (child: UploadsGrid().build(context)),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
                Positioned(
                    bottom: 100,
                    right: 35,
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UploadForm()),
                        );
                      },
                      elevation: 2.0,
                      fillColor: ThemeData.dark().colorScheme.primary.withOpacity(0.5),
                      child: Icon(
                        Entypo.upload,
                        size: 22.0,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    )),
              ],
            );
          }
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ThemeData.dark().colorScheme.primary)));
        },
      ),
    );
  }
}

class UploadsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploadsProvider>(context);
    List<UploadsModel> uploads = Provider.of<List<UploadsModel>>(context);

    //  int length = uploads.length = null ? 1 : uploads.length;
    if (uploads == null) {
      return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ThemeData.dark().colorScheme.primary));
    }
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      child: GridView.builder(
        itemCount: uploads.length ??= 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.6),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                          value: provider,
                          child: SelectedWallpaper(
                            image: uploads[index].img,
                            date: uploads[index].fecha,
                            instagram: uploads[index].instagram,
                            likes: uploads[index].likes,
                            user: uploads[index].user,
                            documentId: uploads[index].documentID,
                            isFromUploadsPage: true,
                          ),
                        )),
                (Route<dynamic> route) => true,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(3, 4), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  image: NetworkImage(uploads[index].img),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
