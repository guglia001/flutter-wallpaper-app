
import 'dart:convert';

SearchUnspash searchUnspashFromJson(String str) => SearchUnspash.fromJson(json.decode(str));

String searchUnspashToJson(SearchUnspash data) => json.encode(data.toJson());

class SearchUnspash {
    SearchUnspash({
        this.results,
    });

    List<Result> results;

    factory SearchUnspash.fromJson(Map<String, dynamic> json) => SearchUnspash(
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class Result {
    Result({
        this.id,
        this.width,
        this.height,
        this.urls,
    });

    String id;
    int width;
    int height;
    Urls urls;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        urls: Urls.fromJson(json["urls"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "width": width,
        "height": height,
        "urls": urls.toJson(),
    };
}

class Urls {
    Urls({
        this.raw,
        this.full,
        this.regular,
        this.small,
        this.thumb,
    });

    String raw;
    String full;
    String regular;
    String small;
    String thumb;

    factory Urls.fromJson(Map<String, dynamic> json) => Urls(
        raw: json["raw"],
        full: json["full"],
        regular: json["regular"],
        small: json["small"],
        thumb: json["thumb"],
    );

    Map<String, dynamic> toJson() => {
        "raw": raw,
        "full": full,
        "regular": regular,
        "small": small,
        "thumb": thumb,
    };
}
