import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rickandmorty/app/router.dart';
import 'package:rickandmorty/models/episode_model.dart';

class EpisodesListview extends StatefulWidget {
  final List<EpisodeModel> episodes;
  final bool loadMore;
  final VoidCallback? onLoadMore;
  const EpisodesListview({
    super.key,
    required this.episodes,
    this.onLoadMore,
    this.loadMore = false,
  });

  @override
  State<EpisodesListview> createState() => _EpisodesListviewState();
}

class _EpisodesListviewState extends State<EpisodesListview> {
  final _srollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _listenScroll();
  }

  void _listenScroll() {
    if (widget.onLoadMore == null) return;
    _srollController.addListener(() {
      final maxScroll = _srollController.position.maxScrollExtent;
      final currentPosition = _srollController.position.pixels;
      final delta = 200;
      if (maxScroll - currentPosition <= delta) {
        widget.onLoadMore!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _srollController,
      padding: EdgeInsets.zero,
      itemCount: widget.episodes.length,
      itemBuilder: (context, index) {
        final EpisodeModel model = widget.episodes[index];
        return Column(
          children: [
            ListTile(
              onTap: () =>
                  context.push(AppRoutes.sectionCharacters, extra: model),
              leading: Icon(Icons.face_retouching_natural, size: 36),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(
                model.episode,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(model.name, style: TextStyle(fontSize: 12)),
            ),
            if (widget.loadMore && index == widget.episodes.length - 1)
              const CircularProgressIndicator.adaptive(),
          ],
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Theme.of(context).colorScheme.tertiary,
        indent: 30,
        endIndent: 30,
        height: 0,
      ),
    );
  }
}
