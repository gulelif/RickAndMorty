import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rickandmorty/app/locator.dart';
import 'package:rickandmorty/models/characters_model.dart';
import 'package:rickandmorty/services/api_service.dart';

enum ChracterType { all, alive, dead, unknown }

class CharactersViewModel extends ChangeNotifier {
  final _apiService = locator<ApiService>();

  ChracterType _characterType = ChracterType.all;
  ChracterType get characterType => _characterType;

  String _searchText = '';
  String get searchText => _searchText;

  CharactersModel? _charactersModel;
  CharactersModel? get charactersModel => _charactersModel;

  bool loadMore = false;
  int currentPageIndex = 1;
  Timer? _debounce;

  void setSearchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  void setCharacterType(ChracterType type) {
    _characterType = type;
    notifyListeners();
  }

  Future<void> getCharacters({String? name, ChracterType? type}) async {
    if (name != null) _searchText = name;
    if (type != null) _characterType = type;

    currentPageIndex = 1;
    _charactersModel = null;
    notifyListeners();

    Map<String, dynamic> args = {};

    if (_searchText.isNotEmpty) {
      args['name'] = _searchText;
    }
    if (_characterType != ChracterType.all) {
      args['status'] = _characterType.name;
    }

    final apiArgs = args.isEmpty ? null : args;

    _charactersModel = await _apiService.getCharacters(args: apiArgs);
    notifyListeners();
  }

  void clearCharacters() {
    _charactersModel = null;
    currentPageIndex = 1;
    notifyListeners();
  }

  Future<void> getCharactersMore() async {
    if (loadMore || _charactersModel?.info?.pages == currentPageIndex) return;

    setLoadMore(true);

    final data = await _apiService.getCharacters(
      url: _charactersModel!.info?.next,
    );

    setLoadMore(false);

    _charactersModel!.info = data?.info;
    _charactersModel!.characters?.addAll(data!.characters);
    notifyListeners();
  }

  void setLoadMore(bool value) {
    loadMore = value;
    notifyListeners();
  }

  void getCharactersByName(String name) {
    setSearchText(name);

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await getCharacters(name: name);
    });
  }

  Future<void> onCharacterTypeChanged(ChracterType type) async {
    setCharacterType(type);
    await getCharacters(type: type);
  }
}
