import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/app/locator.dart';
import 'package:rickandmorty/models/characters_model.dart';
import 'package:rickandmorty/services/preferences_service.dart';
import 'package:rickandmorty/services/global_update_provider.dart';
import 'character_cardview.dart';

class CharacterCardListView extends StatefulWidget {
  final List<CharacterModel> characters;
  final VoidCallback? onLoadMore;
  final bool loadMore;

  const CharacterCardListView({
    super.key,
    required this.characters,
    this.onLoadMore,
    this.loadMore = false,
  });

  @override
  State<CharacterCardListView> createState() => _CharacterCardListViewState();
}

class _CharacterCardListViewState extends State<CharacterCardListView> {
  final _scrollController = ScrollController();
  final _preferencesService = locator<PreferencesService>();

  bool _isLoading = true;
  List<int> _favoritedList = [];
  late GlobalUpdateNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = context
        .read<GlobalUpdateNotifier>(); // context üzerinden alınmalı
    _getFavorites();
    _detectScrollBottom();
    _notifier.addListener(_onFavoritesChanged);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    setState(() {});
  }

  void _getFavorites() async {
    _favoritedList = _preferencesService.getSavedCharacters();
    _setLoading(false);
  }

  void _onFavoritesChanged() {
    _getFavorites(); // Favori değişince güncelle
  }

  void _detectScrollBottom() {
    if (widget.onLoadMore != null) {
      _scrollController.addListener(() {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentPosition = _scrollController.position.pixels;
        const int delta = 200;

        if (maxScroll - currentPosition <= delta) {
          widget.onLoadMore!();
        }
      });
    }
  }

  @override
  void dispose() {
    _notifier.removeListener(_onFavoritesChanged);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CircularProgressIndicator.adaptive();
    } else {
      return Flexible(
        child: ListView.builder(
          itemCount: widget.characters.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            final characterModel = widget.characters[index];
            final bool isFavorited = _favoritedList.contains(characterModel.id);
            return Column(
              children: [
                CharacterCardView(
                  characterModel: characterModel,
                  isFavorited: isFavorited,
                ),
                if (widget.loadMore && index == widget.characters.length - 1)
                  const CircularProgressIndicator.adaptive(),
              ],
            );
          },
        ),
      );
    }
  }
}
