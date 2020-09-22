import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallpaper_dope/src/models/trendy_model.dart';
import 'package:http/http.dart' as http;

class TrendingProvider extends ChangeNotifier {
  String _url = "https://api.pexels.com/v1/search?query=iphone wallpaper&page=";
  String _api = '563492ad6f91700001000001ed215a17288e400e962e3dc1628e2fcc';
  int _page = 0;
  bool _cargando = false;
  List<Photo> page = new List();

  final _pageStream = StreamController<List<Photo>>.broadcast();
  Function(List<Photo>) get pageSink => _pageStream.sink.add;
  Stream<List<Photo>> get pageStream => _pageStream.stream;

  disposeStrems() {
    _pageStream?.close();
  }

  searchTrendy() async {
    if (_cargando) return [];
    _cargando = true;
    _page++;

    final req = await http.get(_url + _page.toString(),
        headers: {HttpHeaders.authorizationHeader: _api});

    final json = jsonDecode(req.body);
    final resp = TrendyModel.fromJson(json);
    pageSink(page);
    page.addAll(resp.photos);

    _cargando = false;
  }
}
