class DBModel {
  DBModel({
    this.id,
    this.image,
    this.lowResImage,
  });
  int id;
  String image;
  String lowResImage;

  factory DBModel.fromJson(Map<String, dynamic> json) => DBModel(
        id: json["id"],
        image: json["url"],
        lowResImage: json["lowResUrl"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "url": image,
        "lowResUrl": lowResImage
      };
}
