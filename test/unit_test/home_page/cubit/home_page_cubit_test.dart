import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart';
import 'package:drift_app_testble/domain/repository/todo_repository.dart';
import 'package:drift_app_testble/helpers/unit_todo_factory.dart';
import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


const _initCompletedState = HomePageUpdatedState(
  todos: [],
  filter: FilterKind.all,
);

final stateWithTodos = HomePageUpdatedState(
  todos: todosList,
  filter: FilterKind.all,
);

final _todo1 = UnitTodoFactory.todo1;
final _todo2 = UnitTodoFactory.todo2;
final _todo3 = UnitTodoFactory.todo3;

class MockTodoService extends Mock implements TodoRepository {}

final todosList = [_todo1, _todo2, _todo3];

void main() {
  late HomePageCubit homeCubit;
  late TodoRepository mockService;

  setUp(() async {
    mockService = MockTodoService();
    homeCubit = HomePageCubit(todoRepository: mockService);
  });

  group(
    'Testing [Home Cubit]',
    () {
      blocTest('Test get todos on init cubit',
          build: () {
            when(() => mockService.getTodos()).thenAnswer(
              (_) async => todosList,
            );
            return homeCubit;
          },
          act: (cubit) => cubit.getTodos(FilterKind.all),
          expect: () => [stateWithTodos],
          verify: (_) {
            verify(() => mockService.getTodos(query: null)).called(1);
          });

      blocTest(
        'Test get todos',
        act: (cubit) => cubit.getTodos(FilterKind.all),
        build: () {
          when(() => mockService.getTodos()).thenAnswer((_) async => todosList);
          return homeCubit;
        },
        expect: () => [stateWithTodos],
      );

      blocTest(
        'Test watch todos',
        act: (cubit) => cubit.watchTodos(),
        build: () {
          when(() => mockService.watchTodos())
              .thenAnswer((_) => Stream.fromIterable(
                    [todosList],
                  ));
          return homeCubit;
        },
        expect: () => [stateWithTodos],
      );

      blocTest(
        'emits [UpdatedState] with todo items after get Todos',
        build: () {
          when(() => mockService.getTodos()).thenAnswer((_) async => todosList);
          return homeCubit;
        },
        act: (cubit) => cubit.updateFilter(filter: FilterKind.all),
        expect: () => [stateWithTodos],
      );

      blocTest(
        'emits [UpdatedState] and show completed only = after update filter',
        build: () {
          when(() => mockService.getCompleteOrOnly(isCompleted: true))
              .thenAnswer(
            (_) async {
              final result = todosList
                  .map((e) => (e.title == _todo2.title)
                      ? e.copyWith(isCompleted: const Value(true))
                      : e)
                  .where(
                    (element) => element.isCompleted == true,
                  )
                  .toList();
              return result;
            },
          );
          return homeCubit;
        },
        act: (cubit) => cubit.updateFilter(filter: FilterKind.completed),
        expect: () => [
          HomePageUpdatedState(
            todos: [_todo2.copyWith(isCompleted: const Value(true))],
            filter: FilterKind.completed,
          ),
        ],
        verify: (_) {
          verify(() => mockService.getCompleteOrOnly(isCompleted: true))
              .called(1);
        },
      );

      blocTest(
        'emits [UpdatedState] and show inCompleted only = after update filter',
        build: () {
          when(() => mockService.getCompleteOrOnly(isCompleted: false))
              .thenAnswer(
            (_) async {
              final result = todosList
                  .map((e) => (e.title == _todo3.title)
                      ? e.copyWith(isCompleted: const Value(false))
                      : e)
                  .where(
                    (element) => element.isCompleted == false,
                  )
                  .toList();
              return result;
            },
          );
          return homeCubit;
        },
        act: (cubit) => cubit.updateFilter(filter: FilterKind.incomplete),
        expect: () => [
          HomePageUpdatedState(
            todos: [_todo3.copyWith(isCompleted: const Value(false))],
            filter: FilterKind.incomplete,
          ),
        ],
        verify: (_) {
          verify(() => mockService.getCompleteOrOnly(isCompleted: false))
              .called(1);
        },
      );
    },
  );
}
