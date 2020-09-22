import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:wallpaper_dope/src/models/uploads_model.dart';

class UploadsProvider extends ChangeNotifier {
  FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;

  Stream<List<UploadsModel>> getUploaded() {
    return _firestoreDB
        .collection("user_uploads")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((docs) {
              // final dataConID = docs.data().update("docID", (value) => docs.id);

              final dataConID = docs.data();
              dataConID['docID'] = docs.id;

              return UploadsModel.fromJson(dataConID);
            }).toList());
  }

  bool imagenSeleccionada = false;
  File imagenSeleecionadaFile;

  String imgUrl;

  selecionarImagen() async {
    final _picker = ImagePicker();
    await _picker.getImage(source: ImageSource.gallery).then((value) {
      imagenSeleecionadaFile = File(value.path);
      imagenSeleccionada = true;
      notifyListeners();
    });
  }

  Future subirImagen() async {
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/solteroski/image/upload?upload_preset=i4c60erd');
    final mimetype = mime(imagenSeleecionadaFile.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath(
        'file', imagenSeleecionadaFile.path,
        contentType: MediaType(mimetype[0], mimetype[1]));

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }
    final respData = json.decode(resp.body);

    imgUrl = respData["secure_url"];

    notifyListeners();
  }

  addNewWallpaper(UploadsModel image) {
    return _firestoreDB.collection("user_uploads").add(image.toJson());
  }

// UI Helpers

  bool liked = false;
  int likes;

  like(String documentID) {
    // provider.likes(likes);
    if (liked == false) {
      liked = true;
      ++likes;
      notifyListeners();
      _firestoreDB
          .collection("user_uploads")
          .doc(documentID)
          .update({"likes": likes});
    } else if (liked == true) {
      liked = false;
      notifyListeners();
      _firestoreDB
          .collection("user_uploads")
          .doc(documentID)
          .update({"likes": likes});
    }
  }

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }



  bool _loadingMain = false;

  get loadingMain {
    return _loadingMain;
  }

  set loadingMain(bool loading) {
    this._loadingMain = loading;
    notifyListeners();
  }
}
