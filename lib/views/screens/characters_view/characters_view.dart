import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/services/global_update_provider.dart';
import 'package:rickandmorty/views/screens/characters_view/characters_viewmodel.dart';
import 'package:rickandmorty/views/widgets/appbar_widget.dart';
import 'package:rickandmorty/views/widgets/character_card_listview.dart';

class CharactersView extends StatefulWidget {
  const CharactersView({super.key});

  @override
  State<CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<CharactersView> {
  GlobalUpdateNotifier? _notifier;
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();

    _listener = () {
      context.read<CharactersViewModel>().getCharacters();
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Sayfa açıldığında karakterleri çek
      context.read<CharactersViewModel>().getCharacters();

      // Notifier'ı bağla
      _notifier = context.read<GlobalUpdateNotifier>();
      _notifier?.addListener(_listener);
    });
  }

  @override
  void dispose() {
    _notifier?.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CharactersViewModel>();

    return Scaffold(
      appBar: AppbarWidget(title: 'Rick and Morty'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Column(
            children: [
              _searchInputWidget(context, viewModel: viewModel),
              viewModel.charactersModel == null
                  ? const CircularProgressIndicator()
                  : viewModel.charactersModel!.characters.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text(
                          'Hiç karakter bulunamadı',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  : CharacterCardListView(
                      characters: viewModel.charactersModel!.characters,
                      onLoadMore: viewModel.getCharactersMore,
                      loadMore: viewModel.loadMore,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchInputWidget(
    BuildContext context, {
    required CharactersViewModel viewModel,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 16),
      child: TextFormField(
        textInputAction: TextInputAction.search,
        onFieldSubmitted: viewModel.getCharactersByName,
        onChanged: viewModel.getCharactersByName,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: 'Karakterlerde Ara',
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: viewModel.onCharacterTypeChanged,
            itemBuilder: (context) {
              return ChracterType.values.map((e) {
                return PopupMenuItem<ChracterType>(
                  value: e,
                  child: Text(e.name),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
