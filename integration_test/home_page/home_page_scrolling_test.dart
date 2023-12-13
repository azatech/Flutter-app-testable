// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, prefer_const_constructors

import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/helpers/unit_todo_factory.dart';
import 'package:drift_app_testble/page/details_page/cubit/todo_details_cubit.dart';
import 'package:drift_app_testble/page/details_page/todo_details_page.dart';
import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:drift_app_testble/page/home/home_page.dart';
import 'package:drift_app_testble/page/services/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepo extends Mock implements TodoRepository {}

Widget wrapMaterialWidget(Widget child) => MaterialApp(home: child);

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget homeBaseWidget;
  late HomePageCubit homePageCubit;
  late TodoDetailsCubit todoDetailsPageCubit;
  late TodoRepository mockTodoRepo;

  setUp(() async {
    /// get it base init
    mockTodoRepo = MockTodoRepo();
    getIt.registerLazySingleton<TodoRepository>(() => mockTodoRepo);
    homePageCubit = HomePageCubit(todoRepository: getIt());
    todoDetailsPageCubit = TodoDetailsCubit(
      todoRepository: getIt(),
      todo: UnitTodoFactory.todo15,
    );
    getIt.registerFactory<HomePageCubit>(() => homePageCubit);
    getIt.registerFactory<TodoDetailsCubit>(() => todoDetailsPageCubit);

    when(() => mockTodoRepo.getTodos()).thenAnswer((_) async => []);
    when(() => mockTodoRepo.watchTodos()).thenAnswer(
      (_) => Stream.fromIterable([]),
    );

    homeBaseWidget = wrapMaterialWidget(
      BlocProvider(
        create: (context) => homePageCubit,
        lazy: false,
        child: const HomePage(),
      ),
    );
  });

  tearDown(() async {
    /// destroy get it
    getIt.reset();
  });

  group('Test scrolling behaviour', () {
    testWidgets('Test many todos in list', (tester) async {
      final visibleTodo = UnitTodoFactory.todo15;
      when(() => mockTodoRepo.getTodos()).thenAnswer(
        (_) async => [...UnitTodoFactory.fullListTodos],
      );
      await tester.pumpWidget(homeBaseWidget);
      homePageCubit.getTodos(FilterKind.all);

      /// Wait till network or cache request has done
      await tester.pumpAndSettle(Duration(seconds: 1));

      /// take last because the tab bar up top is also a Scrollable
      final scrollableListFinder = find.byType(Scrollable).last;

      final cardFinder = find.byKey(Key(todoCardKey(15)));
      await binding.traceAction(
        () async {
          await tester.scrollUntilVisible(
            cardFinder,
            200.0,
            scrollable: scrollableListFinder,
            duration: Duration(seconds: 1),
          );
        },
        reportKey: 'scrolling_timeline',
      );

      await tester.tap(cardFinder);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(TodoDetailsPage), findsOneWidget);

      final todoTitle = visibleTodo.title;
      final todoDesc = visibleTodo.description ?? '';

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
