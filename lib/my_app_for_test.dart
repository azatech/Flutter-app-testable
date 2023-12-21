import 'package:drift_app_testble/data/services/for_test/fake_todo_service_for_t.dart';
import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:drift_app_testble/page/home/fake_home_page_for_performance_test/fake_home_performance_test_page.dart';
import 'package:drift_app_testble/page/services/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppForTest extends StatelessWidget {
  const MyAppForTest({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<HomePageCubit>(

              /// Fake service injection
              param1: FakeTodoServiceForT(
                appDb: getIt(),
              ),
            ),
            lazy: false,
          ),
        ],
        child: const FakeHomePerformanceTestPage(),
      ),
    );
  }
}
