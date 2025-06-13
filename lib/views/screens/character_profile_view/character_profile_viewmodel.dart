import 'package:flutter/material.dart';
import 'package:rickandmorty/app/locator.dart';
import 'package:rickandmorty/models/episode_model.dart';
import 'package:rickandmorty/services/api_service.dart';

class CharacterProfileViewmodel extends ChangeNotifier {
  final _apiservice = locator<ApiService>();
  List<EpisodeModel> _episodes = [];
  List<EpisodeModel> get episodes => _episodes;

  void getEpisodes(List<String> urlList) async {
    _episodes = await _apiservice.getMultipleEpisodes(urlList);
    notifyListeners();
  }
}
