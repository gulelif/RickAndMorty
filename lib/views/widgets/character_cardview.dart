import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rickandmorty/app/locator.dart';
import 'package:rickandmorty/app/router.dart';
import 'package:rickandmorty/models/characters_modal.dart';
import 'package:rickandmorty/services/preferences_service.dart';

class CharacterCardView extends StatefulWidget {
  final CharacterModel characterModel;
  bool isFavorited;

  CharacterCardView({
    super.key,
    required this.characterModel,
    this.isFavorited = false,
  });

  @override
  State<CharacterCardView> createState() => _CharacterCardViewState();
}

class _CharacterCardViewState extends State<CharacterCardView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //tıklama için Inkwell veya GestureDetector kullanılabilir
      onTap: () => context.push(
        AppRoutes.characterProfile,
        extra: widget.characterModel,
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 7),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    //resme radius vermek için
                    borderRadius: BorderRadiusGeometry.circular(6),
                    child: Hero(
                      // hero ile resme benzersiz bir tag verdiğimizde aynı tagli iki resim arasında geçiş efekti yapar.
                      tag: widget.characterModel.image,
                      child: Image.network(
                        widget.characterModel.image,
                        height: 100,
                      ),
                    ),
                  ),
                  SizedBox(width: 17),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 17),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, //sağdan sola hizalama
                      children: [
                        Text(
                          widget.characterModel.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),

                        _infoWidget(
                          type: "Köken",
                          value: widget.characterModel.origin.name,
                        ),

                        SizedBox(height: 3),

                        _infoWidget(
                          type: "Durum",
                          value:
                              '${widget.characterModel.status} - ${widget.characterModel.species}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                _favoriteCharacter();
              },
              icon: Icon(
                widget.isFavorited ? Icons.bookmark : Icons.bookmark_border,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _favoriteCharacter() {
    if (widget.isFavorited) {
      locator<PreferencesService>().removeCharacter(widget.characterModel.id);
      widget.isFavorited = false;
    } else {
      locator<PreferencesService>().saveCharacter(widget.characterModel.id);
      widget.isFavorited = true;
    }

    setState(() {});
  }

  Column _infoWidget({required String type, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, //sağdan sola hizalama
      children: [
        Text(type, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300)),
        Text(value, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
