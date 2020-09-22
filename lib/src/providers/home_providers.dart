import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:wallpaper_dope/src/models/unsplash_search_model.dart';

class HomeProviderUnsplash extends ChangeNotifier {
  final url =
      'https://api.unsplash.com/search/photos?client_id=sBa4uFHmQqwguutFmXoYiD-gZGNsP1d34N0h-dkxy-Y&per_page=5';
  int _hypePage = 0;
  int _shoesPage = 0;
  int _snapsPage = 0;
  int _moneyPage = 0;
  bool _cargandoHype = false , _cargandoShoes = false , _cargandoSnaps = false, _cargandoMoney = false;

  List<Result> hype = new List();
  List<Result> shoes = new List();
  List<Result> snaps = new List();
  List<Result> money = new List();

  //STREAMS  !!!!

  final _hypeStream = StreamController<List<Result>>.broadcast();
  Function(List<Result>) get hypeSink => _hypeStream.sink.add;
  Stream<List<Result>> get hypeStream => _hypeStream.stream;

  final _shoesStream = StreamController<List<Result>>.broadcast();
  Function(List<Result>) get shoesSink => _shoesStream.sink.add;
  Stream<List<Result>> get shoesStream => _shoesStream.stream;

  final _snapStream = StreamController<List<Result>>.broadcast();
  Function(List<Result>) get snapSink => _snapStream.sink.add;
  Stream<List<Result>> get snapStream => _snapStream.stream;

  final _moneyStream = StreamController<List<Result>>.broadcast();
  Function(List<Result>) get moneySink => _moneyStream.sink.add;
  Stream<List<Result>> get moneyStream => _moneyStream.stream;

  disposeStreams() {
    _hypeStream?.close();
    _shoesStream?.close();
    _snapStream?.close();
    _moneyStream?.close();
  }

  //FUNCIONES !!!
   searchHype() async {
    if (_cargandoHype) return [];
    _cargandoHype = true;
    _hypePage++;

    final query = '&query=hype';
    final page = '&page=$_hypePage';
    print(url + query + page);

    final req = await http.get(url + query + page);

    final json = jsonDecode(req.body);

    final resp = SearchUnspash.fromJson(json);

    hypeSink(hype);
     hype.addAll(resp.results);

    _cargandoHype = false;

  }

  searchShoes() async {
    if (_cargandoShoes) return [];

    _cargandoShoes = true;

    _shoesPage++;

    final query = '&query=Hype shoes';
    final page = '&page=$_shoesPage';

    final req = await http.get(url + query + page);

    
    final json = jsonDecode(req.body);

    final resp = SearchUnspash.fromJson(json);

    shoes.addAll(resp.results);

    shoesSink(shoes);
    _cargandoShoes = false;

  }

  searchSnaps() async {
    if (_cargandoSnaps) return [];

    _cargandoSnaps = true;

    _snapsPage++;

    final query = '&query=snaps';
    final page = '&page=$_snapsPage';

    final req = await http.get(url + query + page);

    final json = jsonDecode(req.body);

    final resp = SearchUnspash.fromJson(json);

    snaps.addAll(resp.results);
    
    snapSink(snaps);
    _cargandoSnaps = false;
  }

  searchMoney() async {
    if (_cargandoMoney) return [];

    _cargandoMoney = true;

    _moneyPage++;

    final query = '&query=rich';
    final page = '&page=$_moneyPage';

    final req = await http.get(url + query + page);

    
    final json = jsonDecode(req.body);

    final resp = SearchUnspash.fromJson(json);

    money.addAll(resp.results);

    moneySink(money);
    _cargandoMoney = false;

  }
}
