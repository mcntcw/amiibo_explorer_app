import 'package:amiibo_explorer_app/core/domain/amiibo.dart';
import 'package:amiibo_explorer_app/search/presentation/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchInitial) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LogoText(),
                      const SizedBox(height: 24),
                      SearchBar(
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
                    ResultsHeader(
                      query: state.query,
                      onRefresh: () {
                        context.read<SearchBloc>().add(SearchCleared());
                        _controller.clear();
                      },
                    ),
                    SizedBox(height: 12),
                    ResultsList(results: state.results),
                  ],
                );
              } else if (state is SearchLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                );
              } else if (state is SearchEmpty) {
                return StatusMessage(
                  isFailure: false,
                  onReset: () {
                    context.read<SearchBloc>().add(SearchCleared());
                    _controller.clear();
                  },
                );
              } else if (state is SearchFailure) {
                return StatusMessage(
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

class SearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onSearch;
  final FocusNode? focusNode;
  final bool autofocus;

  const SearchBar({
    super.key,
    this.controller,
    this.hintText = "What Amiibo are you looking for?",
    this.onSearch,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autofocus,
            textInputAction: TextInputAction.search,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: colorScheme.onSurface,
                size: 18,
              ),
              contentPadding: const EdgeInsets.all(16),
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withAlpha(100),
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: colorScheme.primary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onSearch, // trigger BLoC action via callback
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.onSurface,
            ),
            child: Icon(
              Icons.arrow_upward_rounded,
              color: colorScheme.primary,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class LogoText extends StatelessWidget {
  const LogoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Amiibo Explorer",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class StatusMessage extends StatelessWidget {
  final bool isFailure;
  final VoidCallback? onReset;

  const StatusMessage({super.key, required this.isFailure, this.onReset});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final text = isFailure ? "Something went wrong" : "No results found";

    return Center(
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
                child: Icon(Icons.refresh, color: scheme.primary, size: 16),
              ),
            ),
        ],
      ),
    );
  }
}

class ResultsHeader extends StatelessWidget {
  final String query;
  final VoidCallback? onRefresh;

  const ResultsHeader({super.key, required this.query, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Results for "$query"',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface.withAlpha(200),
            ),
          ),
        ),
        GestureDetector(
          onTap: onRefresh,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.onSurface,
            ),
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: scheme.primary,
              size: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class ResultsList extends StatelessWidget {
  final List<Amiibo> results;

  const ResultsList({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, int index) {
          return AmiiboCard(amiibo: results[index]);
        },
      ),
    );
  }
}

class AmiiboCard extends StatelessWidget {
  final Amiibo amiibo;
  final VoidCallback? onTap;

  const AmiiboCard({super.key, required this.amiibo, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
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
                  shape: BoxShape.circle,
                  color: scheme.surface,
                  image: DecorationImage(
                    image: NetworkImage(amiibo.image) as ImageProvider<Object>,
                    fit: BoxFit.cover,
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
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$amiiboSeries • $gameSeries',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            color: scheme.onSurface.withAlpha(180),
          ),
        ),
        if (releaseDate != null && releaseDate!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Release: $releaseDate',
            style: TextStyle(
              fontSize: 12,
              color: scheme.onSurface.withAlpha(180),
            ),
          ),
        ],
      ],
    );
  }
}
