import 'package:flutter/cupertino.dart';
import 'package:rickandmorty/app/locator.dart';
import 'package:rickandmorty/models/characters_model.dart';
import 'package:rickandmorty/services/api_service.dart';
import 'package:rickandmorty/services/preferences_service.dart';

class FavouritesViewModel extends ChangeNotifier {
  final _preferencesService = locator<PreferencesService>();
  final _apiService = locator<ApiService>();

  List<int> _favourites = [];
  List<CharacterModel> _characters = [];
  List<CharacterModel> get characters => _characters;

  bool isLoading = true;
  void setisLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> getFavourites() async {
    setisLoading(true);

    _favourites = _preferencesService.getSavedCharacters();

    await _getCharacters();
    setisLoading(false);
  }

  Future<void> _getCharacters() async {
    if (_favourites.isEmpty) {
      _characters = [];
    } else {
      _characters = await _apiService.getMultipleCharacters(_favourites);
    }
  }
}
