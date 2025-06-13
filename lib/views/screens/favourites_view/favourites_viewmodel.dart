import 'package:flutter/cupertino.dart';
import 'package:rickandmorty/app/locator.dart';
import 'package:rickandmorty/models/characters_modal.dart';
import 'package:rickandmorty/services/api_service.dart';
import 'package:rickandmorty/services/preferences_service.dart';

class FavouritesViewModel extends ChangeNotifier {
  final _preferencesService = locator<PreferencesService>();
  final _apiService = locator<ApiService>();

  List<int> _favourites = [];
  List<CharacterModel> _characters = [];
  List<CharacterModel> get characters => _characters;

  bool isLoading = true;

  Future<void> getFavourites() async {
    isLoading = true;
    notifyListeners();

    _favourites = _preferencesService.getSavedCharacters();

    await _getCharacters();

    isLoading = false;
    notifyListeners();
  }

  Future<void> _getCharacters() async {
    if (_favourites.isEmpty) {
      _characters = [];
    } else {
      _characters = await _apiService.getMultipleCharacters(_favourites);
    }
  }
}
