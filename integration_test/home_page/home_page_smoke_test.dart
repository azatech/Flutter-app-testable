// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, prefer_const_constructors

import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/helpers/unit_todo_factory.dart';
import 'package:drift_app_testble/page/details_page/todo_details_page.dart';
import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:drift_app_testble/page/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../test/unit_test/home_page/cubit/home_page_cubit_test.dart';
import '../helpers/material_wrapper.dart';
import '../test_app_helper.dart';

final _todo1 = UnitTodoFactory.todo1;
final _todo2 = UnitTodoFactory.todo2;
final _todo3 = UnitTodoFactory.todo3;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget homeWidget;
  late HomePageCubit homeCubit;
  late TodoRepository mockRepository;

  setUp(() async {
    final (homeW, homeC, _, mockR) = TestAppHelper.setUpHomeMain();
    homeWidget = homeW;
    homeCubit = homeC;
    mockRepository = mockR;
  });

  tearDown(() async {
    TestAppHelper.reset();
  });

  group('Home page initial empty UI smoke tests', () {
    testWidgets('App Bar title widget test', (tester) async {
      await tester.pumpWidget(homeWidget);
      final titleFinder = find.text(titleAppName);
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('Test initial Empty list text in widget tree', (tester) async {
      await tester.pumpWidget(homeWidget);

      final titleFinder = find.text(emptyListTitle);
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('Test check exist of search icon in widget tree',
        (tester) async {
      await tester.pumpWidget(MaterialWrapper(homeWidget));
      final iconSearch = find.byIcon(Icons.search);
      expect(iconSearch, findsOneWidget);
    });
  });

  group('Home page - with data UI smoke tests', () {
    testWidgets('Filled with data smoke test', (tester) async {
      when(() => mockRepository.getTodos())
          .thenAnswer((_) async => [_todo1, _todo2, _todo3]);
      await tester.pumpWidget(homeWidget);
      homeCubit.getTodos(FilterKind.all);
      await tester.pumpAndSettle();
      expect(find.text(_todo1.title), findsOneWidget);
      expect(find.text(_todo2.title), findsOneWidget);
      expect(find.text(_todo3.title), findsNWidgets(1));
    });
  });

  group('Test navigation stack Home Page to Details page', () {
    testWidgets('Test navigation builder from Home Page to Details page',
        (tester) async {
      when(() => mockRepository.getTodos())
          .thenAnswer((_) async => [_todo1, _todo2, _todo3]);
      await tester.pumpWidget(homeWidget);
      homeCubit.getTodos(FilterKind.all);

      /// Wait till network or cache request has done
      await tester.pumpAndSettle();

      final todoOneFinder = find.text(_todo1.title);
      await tester.tap(todoOneFinder);
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(TodoDetailsPage), findsOneWidget);

      await tester.pump();

      final todoTitle = _todo1.title;
      final todoDesc = _todo1.description ?? '';

      final titleForm = find.byKey(const Key('title_details_form'));
      final descForm = find.byKey(const Key('description_details_form'));
      final title = (tester.element(titleForm).widget as TextFormField)
              .controller
              ?.value
              .text ??
          '';
      expect(title, todoTitle);

      final desc = (tester.element(descForm).widget as TextFormField)
              .controller
              ?.value
              .text ??
          '';
      expect(desc, todoDesc);
      expect(titleForm, findsOneWidget);
      expect(descForm, findsOneWidget);
    });
  });
}
