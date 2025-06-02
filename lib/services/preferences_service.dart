import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences prefs;

  PreferencesService({required this.prefs});
  final String _characterKey = 'characters';
  void saveCharacter(int id) async {
    final characterList = await prefs.getStringList(_characterKey) ?? [];
    characterList.add(id.toString());
    storeCharacters(characterList);
  }

  void storeCharacters(List<String> characterList) async {
    await prefs.setStringList(_characterKey, characterList);
  }

  void removeCharacter(int id) async {
    final characterList = await prefs.getStringList(_characterKey) ?? [];
    characterList.remove(id.toString());
    prefs.setStringList(_characterKey, characterList);
  }

  List<int> getSavedCharacters() {
    final characterList = prefs.getStringList(_characterKey) ?? [];
    return characterList.map((e) => int.parse(e)).toList();
  }
}
