import 'package:amiibo_explorer_app/core/domain/amiibo.dart';
import 'package:amiibo_explorer_app/search/presentation/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchInitial) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LogoText(),
                      const SizedBox(height: 24),
                      _SearchBar(
                        controller: _controller,
                        autofocus: true,
                        onSearch: () {
                          final query = _controller.text;
                          context.read<SearchBloc>().add(
                            SearchRequested(query),
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else if (state is SearchSuccess) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ResultsHeader(
                      query: state.query,
                      count: state.results.length,
                      onRefresh: () {
                        context.read<SearchBloc>().add(SearchCleared());
                        _controller.clear();
                      },
                    ),
                    SizedBox(height: 12),
                    _ResultsList(
                      results: state.results,
                      onTap: (amiibo) {
                        // Navigate to details screen with GetX and pass the model
                        Get.toNamed('/amiibo-details', arguments: amiibo);
                      },
                    ),
                  ],
                );
              } else if (state is SearchLoading) {
                return Center(
                  child: LoadingAnimationWidget.stretchedDots(
                    color: scheme.onSurface,
                    size: 20,
                  ),
                );
              } else if (state is SearchEmpty) {
                return _StatusMessage(
                  isFailure: false,
                  onReset: () {
                    context.read<SearchBloc>().add(SearchCleared());
                    _controller.clear();
                  },
                );
              } else if (state is SearchFailure) {
                return _StatusMessage(
                  isFailure: true,
                  onReset: () {
                    context.read<SearchBloc>().add(SearchCleared());
                    _controller.clear();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSearch;

  final bool autofocus;

  const _SearchBar({this.controller, this.onSearch, this.autofocus = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final listenable = controller ?? TextEditingController();

    return Animate(
      effects: [
        FadeEffect(duration: 500.ms),
        ScaleEffect(duration: 500.ms, curve: Curves.easeOutBack),
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSearch != null ? (_) => onSearch!() : null,
              focusNode: FocusNode(),
              autofocus: autofocus,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: scheme.onSurface,
                  size: 18,
                ),
                contentPadding: const EdgeInsets.all(16),
                hintText: "What Amiibo are you looking for?",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: scheme.onSurface.withAlpha(100),
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: scheme.primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: listenable,
            builder: (context, value, _) {
              final isEmpty = value.text.trim().isEmpty;
              return GestureDetector(
                onTap: onSearch,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: isEmpty
                        ? scheme.onSurface.withAlpha(120)
                        : scheme.onSurface,
                  ),
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    color: scheme.primary,
                    size: 16,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LogoText extends StatelessWidget {
  const _LogoText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Amiibo Explorer",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ).animate(effects: [FadeEffect(duration: 1000.ms)]);
  }
}

class _StatusMessage extends StatelessWidget {
  final bool isFailure;
  final VoidCallback? onReset;

  const _StatusMessage({required this.isFailure, required this.onReset});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final text = isFailure ? "Something went wrong" : "No results found";

    return Animate(
      effects: [FadeEffect(duration: 300.ms)],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: scheme.onSurface.withAlpha(120),
              ),
            ),
            const SizedBox(height: 16),
            if (onReset != null)
              GestureDetector(
                onTap: onReset,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.onSurface,
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: scheme.primary,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  final String query;
  final int count;
  final VoidCallback? onRefresh;

  const _ResultsHeader({
    required this.query,
    required this.count,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '$count results for "$query"',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withAlpha(200),
            ),
          ),
        ),
        GestureDetector(
          onTap: onRefresh,
          child: Icon(
            Icons.keyboard_arrow_left,
            color: scheme.onSurface.withAlpha(220),
            size: 40,
          ),
        ),
      ],
    );
  }
}

class _ResultsList extends StatelessWidget {
  final List<Amiibo> results;
  final void Function(Amiibo)? onTap;

  const _ResultsList({required this.results, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [FadeEffect(duration: 500.ms)],
      child: Expanded(
        child: ListView.builder(
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            final amiibo = results[index];
            return _AmiiboCard(
              amiibo: amiibo,
              onTap: () => onTap?.call(amiibo), // pass the tapped item
            );
          },
        ),
      ),
    );
  }
}

class _AmiiboCard extends StatelessWidget {
  final Amiibo amiibo;
  final VoidCallback? onTap;

  const _AmiiboCard({required this.amiibo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: scheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(amiibo.image) as ImageProvider<Object>,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: _Details(
                  name: amiibo.name,
                  amiiboSeries: amiibo.amiiboSeries,
                  gameSeries: amiibo.gameSeries,
                  releaseDate: amiibo.releaseDate,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final String name;
  final String amiiboSeries;
  final String gameSeries;
  final String? releaseDate;

  const _Details({
    required this.name,
    required this.amiiboSeries,
    required this.gameSeries,
    required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$amiiboSeries • $gameSeries',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: scheme.onSurface.withAlpha(220),
          ),
        ),
        if (releaseDate != null && releaseDate!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            releaseDate!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: scheme.onSurface.withAlpha(180),
            ),
          ),
        ],
      ],
    );
  }
}
