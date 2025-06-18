import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/services/global_update_provider.dart';
import 'package:rickandmorty/views/screens/favourites_view/favourites_viewmodel.dart';
import 'package:rickandmorty/views/widgets/appbar_widget.dart';
import 'package:rickandmorty/views/widgets/character_card_listview.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({super.key});

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  GlobalUpdateNotifier? _notifier;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();

    _listener = () {
      context.read<FavouritesViewModel>().getFavourites();
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // İlk veri çekme
      context.read<FavouritesViewModel>().getFavourites();

      // Güvenli erişim
      final notifier = context.read<GlobalUpdateNotifier>();
      notifier.addListener(_listener);
      _notifier = notifier;
    });
  }

  @override
  void dispose() {
    _notifier?.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FavouritesViewModel>();

    return Scaffold(
      appBar: AppbarWidget(title: 'Favorilerim'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: viewModel.isLoading
              ? const CircularProgressIndicator.adaptive()
              : viewModel.characters.isEmpty
              ? const Text('Favori yok')
              : CharacterCardListView(characters: viewModel.characters),
        ),
      ),
    );
  }
}
