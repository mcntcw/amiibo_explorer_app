import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo.dart';

class AmiiboDetailsScreen extends StatelessWidget {
  final Amiibo amiibo = Get.arguments as Amiibo;

  AmiiboDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderImageAndBack(amiibo: amiibo),
            _AmiiboDescription(amiibo: amiibo),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 36.0),
        child: _BottomInfoTile(head: amiibo.head, tail: amiibo.tail),
      ),
    );
  }
}

class _HeaderImageAndBack extends StatelessWidget {
  final Amiibo amiibo;
  const _HeaderImageAndBack({required this.amiibo});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(80),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(amiibo.image, fit: BoxFit.contain),
          ),
        ),
        Positioned(
          top: 72,
          left: 8,
          child: IconButton(
            onPressed: Get.back,
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: scheme.onSurface.withAlpha(220),
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}

class _AmiiboDescription extends StatelessWidget {
  final Amiibo amiibo;
  const _AmiiboDescription({required this.amiibo});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget value(String text) => Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
    Widget category(String text) => Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: scheme.onSurface.withAlpha(120),
        fontWeight: FontWeight.w600,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                amiibo.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: scheme.onSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  amiibo.type.toLowerCase(),
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          category('Amiibo series'),
          value(amiibo.amiiboSeries),
          SizedBox(height: 10),
          category('Game series'),
          value(amiibo.gameSeries),
          SizedBox(height: 10),
          category('Character'),
          value(amiibo.character),
          SizedBox(height: 10),
          if (amiibo.releaseDate != null && amiibo.releaseDate!.isNotEmpty) ...[
            category('Release date'),
            value(amiibo.releaseDate!),
          ],
        ],
      ),
    );
  }
}

class _BottomInfoTile extends StatelessWidget {
  final String head;
  final String tail;
  const _BottomInfoTile({required this.head, required this.tail});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Head: $head',
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Tail: $tail',
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
