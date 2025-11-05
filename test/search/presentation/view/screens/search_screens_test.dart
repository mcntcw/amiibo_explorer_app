import 'package:amiibo_explorer_app/search/presentation/bloc/search_bloc.dart';
import 'package:amiibo_explorer_app/search/presentation/view/screens/search_screen.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class _FakeSearchEvent extends Fake implements SearchEvent {}

class _FakeSearchState extends Fake implements SearchState {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeSearchEvent());
    registerFallbackValue(_FakeSearchState());
  });

  Widget wrapWithProviders(Widget child, SearchBloc bloc) {
    return MaterialApp(
      home: BlocProvider<SearchBloc>.value(value: bloc, child: child),
    );
  }

  group('SearchScreen widget', () {
    testWidgets('renders initial UI with logo and search bar', (tester) async {
      final bloc = _MockSearchBloc();
      when(() => bloc.state).thenReturn(const SearchInitial());

      await tester.pumpWidget(wrapWithProviders(const SearchScreen(), bloc));
      await tester.pumpAndSettle();

      expect(find.text('Amiibo Explorer'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(
        find.text('Type at least 3 characters to search Amiibo...'),
        findsOneWidget,
      );
    });

    testWidgets('tap arrow with <3 chars does not dispatch search', (
      tester,
    ) async {
      final bloc = _MockSearchBloc();

      // Stub state + stream to satisfy BlocBuilder
      when(() => bloc.state).thenReturn(const SearchInitial());
      whenListen(
        bloc,
        const Stream<SearchState>.empty(),
        initialState: const SearchInitial(),
      );

      await tester.pumpWidget(wrapWithProviders(const SearchScreen(), bloc));
      await tester.pump();

      // Enter 2 chars
      await tester.enterText(find.byType(TextField), 'ma');
      await tester.pump();

      // Tap arrow (disabled)
      await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
      await tester.pump();

      // No events dispatched
      verifyNever(() => bloc.add(any()));
    });

    testWidgets('shows loading spinner when state is SearchLoading', (
      tester,
    ) async {
      final bloc = _MockSearchBloc();
      when(() => bloc.state).thenReturn(const SearchLoading('mario'));

      await tester.pumpWidget(wrapWithProviders(const SearchScreen(), bloc));
      await tester.pump();

      expect(find.byType(Center), findsWidgets);
    });

    testWidgets(
      'dispatches SearchRequested when pressing enter in text field',
      (tester) async {
        final bloc = _MockSearchBloc();
        when(() => bloc.state).thenReturn(const SearchInitial());
        whenListen(
          bloc,
          const Stream<SearchState>.empty(),
          initialState: const SearchInitial(),
        );

        await tester.pumpWidget(wrapWithProviders(const SearchScreen(), bloc));
        await tester.pump();

        await tester.enterText(find.byType(TextField), 'mario');
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pump();

        verify(() => bloc.add(const SearchRequested('mario'))).called(1);
      },
    );

    testWidgets('search button is disabled with less than 3 characters', (
      tester,
    ) async {
      final bloc = _MockSearchBloc();

      when(() => bloc.state).thenReturn(const SearchInitial());
      whenListen(
        bloc,
        const Stream<SearchState>.empty(),
        initialState: const SearchInitial(),
      );

      await tester.pumpWidget(wrapWithProviders(const SearchScreen(), bloc));
      await tester.pump();

      final searchButtonFinder = find.byIcon(Icons.arrow_upward_rounded);

      double currentAlpha() => tester.widget<Icon>(searchButtonFinder).color!.a;

      // Initially disabled
      expect(currentAlpha(), lessThan(1.0));

      await tester.enterText(find.byType(TextField), 'ma');
      await tester.pump();
      expect(currentAlpha(), lessThan(1.0));

      // Enabled with 3 chars
      await tester.enterText(find.byType(TextField), 'mar');
      await tester.pump();
      expect(currentAlpha(), equals(1.0));
    });
  });
}
