import 'package:flutter/material.dart';

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SearchBarRow(
                  controller: _controller,
                  autofocus: true,
                  onSearch: () {
                    final query = _controller.text;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBarRow extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onSearch; // dispatch e.g. ScrollToTopPressed to BLoC
  final FocusNode? focusNode;
  final bool autofocus;

  const SearchBarRow({
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
