// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    final simpleW = MyWidget(title: 'T', message: 'M');
    await tester.pumpWidget(simpleW);
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');
    print(titleFinder.allCandidates);
    print(messageFinder.allCandidates);
    final secondF = find.byWidget(simpleW);

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
    expect(secondF, findsOneWidget);
  });

  // testWidgets('isSameColorAs (container background) ✅', (tester) async {
  //   final content = Container(color: Colors.green);
  //   await tester.pumpWidget(MaterialApp(home: Scaffold(body: content)));
  //   expect(
  //     tester.widget<Container>(find.byType(Container)).color,
  //     isSameColorAs(Colors.green),
  //   );
  // });

  // testWidgets('SOME BACKGROUND !!! SOME WIDGET !!!?? ', (tester) async {
  //   final content = Container(color: Colors.green);
  //   final content2 = MyWidget(title: 'SS', message: '12',);
  //   print(content2.runtimeType);
  //   print(content2.runtimeType);
  //   print(content2.runtimeType);
  //   print(content2.runtimeType);
  //   // await tester.pumpWidget(MaterialApp(home: Scaffold(body: content)));
  //   await tester.pumpWidget(content2);
  //   expect(
  //     tester.widget<MyWidget>(find.byType(MyWidget)),
  //     findsOne,
  //   );
  // });
}

class MyWidget extends StatelessWidget {
  const MyWidget({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('widgets matchers', () {

    testWidgets('findsNothing ✅', (tester) async {
      final content = Text('1');
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: content)));
      expect(find.text('0'), findsNothing);
    });

    testWidgets('findsWidgets ✅', (tester) async {
      final content = Column(children: [Text('1'), Text('1')]);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: content)));
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('findsOneWidget ❌', (tester) async {
      final content = Column(children: [Text('1'), Text('1')]);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: content)));
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('findsAtLeastNWidgets ✅', (tester) async {
      final content = Column(children: [Icon(Icons.flutter_dash), Text('1')]);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: content)));
      expect(find.text('1'), findsAtLeastNWidgets(1));
    });

    testWidgets('findsNWidgets ✅', (tester) async {
      final content = Column(children: [Text('1'), Text('1')]);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: content)));
      expect(find.text('1'), findsNWidgets(2));
    });

    testWidgets('isSameColorAs (container background) ✅', (tester) async {
      final content = Container(color: Colors.green);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: content)));
      expect(
        tester.widget<Container>(find.byType(Container)).color,
        isSameColorAs(Colors.green),
      );
    });

    testWidgets('isSameColorAs (text color) ✅', (tester) async {
      final content = Text('1', style: TextStyle(color: Colors.green));
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: content)));
      expect(
        tester.widget<Text>(find.text('1')).style!.color,
        isSameColorAs(Colors.green),
      );
    });

    testWidgets('isInCard ✅', (tester) async {
      final content = Card(child: Text('1'));
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: content)));
      expect(find.text('1'), isInCard);
    });

    testWidgets('isNotInCard ✅', (tester) async {
      final content = Text('1');
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: content)));
      expect(find.text('1'), isNotInCard);
    });

    testWidgets('throwsAssertionError ✅', (tester) async {
      final builder = () => Container(
            color: Colors.blue,
            decoration: BoxDecoration(color: Colors.blue),
          );
      expect(() => builder(), throwsAssertionError);
    });

    testWidgets('throwsFlutterError ✅', (tester) async {
      final testKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(SizedBox(key: testKey));
      expect(() => Navigator.of(testKey.currentContext!), throwsFlutterError);
    });
  });
}

 */
