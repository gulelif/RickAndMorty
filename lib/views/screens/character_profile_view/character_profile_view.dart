import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/characters_modal.dart';
import 'package:rickandmorty/models/episode_model.dart';
import 'package:rickandmorty/views/screens/character_profile_view/character_profile_viewmodel.dart';
import 'package:rickandmorty/views/widgets/appbar_widget.dart';

class CharacterProfileView extends StatefulWidget {
  final CharacterModel characterModel;
  const CharacterProfileView({super.key, required this.characterModel});

  @override
  State<CharacterProfileView> createState() => _CharacterProfileViewState();
}

class _CharacterProfileViewState extends State<CharacterProfileView> {
  @override
  void initState() {
    super.initState();
    context.read<CharacterProfileViewmodel>().getEpisodes(
      widget.characterModel.episode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppbarWidget(title: 'Karakter', transparentBackground: true),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg-image.png'),
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _characterAvatar(context),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 13),
                      _characterName(),
                      SizedBox(height: 15),
                      _labelsView(context),
                      SizedBox(height: 38),
                      _scenesTitle(),
                      SizedBox(height: 15),
                      _episodeListView(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Flexible _episodeListView() {
    return Flexible(
      child: Consumer<CharacterProfileViewmodel>(
        builder: (context, viewModel, child) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: viewModel.episodes.length,
            itemBuilder: (context, index) {
              final EpisodeModel model = viewModel.episodes[index];
              return ListTile(
                leading: Icon(Icons.face_retouching_natural, size: 36),
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text(
                  model.episode,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(model.name, style: TextStyle(fontSize: 12)),
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: Theme.of(context).colorScheme.tertiary,
              indent: 30,
              endIndent: 30,
              height: 0,
            ),
          );
        },
      ),
    );
  }

  Text _characterName() {
    return Text(
      widget.characterModel.name,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }

  Container _scenesTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        'Bölümler (${widget.characterModel.episode.length})',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  Padding _labelsView(BuildContext context) {
    final labels = [
      widget.characterModel.status,
      widget.characterModel.origin.name,
      widget.characterModel.gender,
      widget.characterModel.species,
    ].where((label) => label.toLowerCase() != 'unknown');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 14,
        spacing: 7,
        children: labels
            .map((label) => _labelWidget(context, label: label))
            .toList(),
      ),
    );
  }

  Container _labelWidget(BuildContext context, {required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: TextStyle(fontSize: 12)),
    );
  }

  Padding _characterAvatar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 90, bottom: 52),
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: CircleAvatar(
          radius: 98,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Hero(
            // hero ile resme benzersiz bir tag verdiğimizde aynı tagli iki resim arasında geçiş efekti yapar.
            tag: widget.characterModel.image,
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.characterModel.image),
              radius: 95,
            ),
          ),
        ),
      ),
    );
  }
}
