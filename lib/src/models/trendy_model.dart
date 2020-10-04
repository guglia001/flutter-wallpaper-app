import 'dart:convert';

TrendyModel trendyModelFromJson(String str) => TrendyModel.fromJson(json.decode(str));

String trendyModelToJson(TrendyModel data) => json.encode(data.toJson());

class TrendyModel {
    TrendyModel({
        this.page,
        this.photos,
    });

    int page;
    List<Photo> photos;

    factory TrendyModel.fromJson(Map<String, dynamic> json) => TrendyModel(
        page: json["page"],
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
    };
}

class Photo {
    Photo({
        this.src,
    });

    Src src;

    factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        src: Src.fromJson(json["src"]),
    );

    Map<String, dynamic> toJson() => {
        "src": src.toJson(),
    };
}

class Src {
    Src({
        this.original,
        this.medium,
        this.small,
    });

    String original;
    String medium;
    String small;

    factory Src.fromJson(Map<String, dynamic> json) => Src(
        original: json["large2x"],
        medium: json["medium"],
        small: json["small"],
    );

    Map<String, dynamic> toJson() => {
        "original": original,
        "medium": medium,
        "small": small,
    };
}
