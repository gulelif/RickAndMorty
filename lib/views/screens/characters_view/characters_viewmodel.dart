import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rickandmorty/app/locator.dart';
import 'package:rickandmorty/models/characters_modal.dart';
import 'package:rickandmorty/services/api_service.dart';

class CharactersViewModel extends ChangeNotifier {
  final _apiService = locator<ApiService>();
  CharactersModel? _charactersModel;
  CharactersModel? get charactersModel => _charactersModel;
  void getCharacters() async {
    _charactersModel = await _apiService.getCharacters();

    notifyListeners();
  }

  bool loadMore = false;
  int currentPageIndex = 1;
  Timer? _debounce;
  void setLoadMore(bool value) {
    loadMore = value;
    notifyListeners();
  }

  void getCharactersMore() async {
    // eğer zaten yükleniyorsa tekrar istek atma
    if (loadMore) return;
    //eğer son sayfada ise tekrar istek atma
    if (_charactersModel!.info?.pages == currentPageIndex) return;
    setLoadMore(true);
    final data = await _apiService.getCharacters(
      url: _charactersModel!.info?.next,
    );
    setLoadMore(false);
    _charactersModel!.info = data?.info;
    _charactersModel!.characters?.addAll(data!.characters);
    notifyListeners();
  }

  void getCharactersByName(String name) async {
    clearCharacters();
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (name.isNotEmpty) {
        _charactersModel = await _apiService.getCharacters(
          args: {'name': name},
        );
      } else {
        _charactersModel = await _apiService
            .getCharacters(); // boşsa hepsini getir
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void clearCharacters() {
    _charactersModel = null;
    currentPageIndex = 1;
    notifyListeners();
  }
}
