import 'package:flutter/cupertino.dart';

class UploadsModel extends ChangeNotifier {
  UploadsModel(
      {this.id,
      this.activada,
      this.fecha,
      this.img,
      this.instagram,
      this.likes,
      this.user,
      this.documentID});

  String id;
  bool activada;
  String fecha;
  String img;
  String instagram;
  int likes;
  String user;
  String documentID;

  UploadsModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        activada = json["activada"],
        fecha = json["fecha"],
        img = json["img"],
        instagram = json["instagram"],
        likes = json["likes"],
        user = json["user"],
        documentID = json["docID"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "activada": activada,
        "fecha": fecha,
        "img": img,
        "instagram": instagram,
        "likes": likes,
        "user": user,
        "docID": documentID
      };
}
