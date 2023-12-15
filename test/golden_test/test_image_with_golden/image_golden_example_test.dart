// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, prefer_const_constructors

import 'package:drift_app_testble/golden_test_example/test_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../integration_test/helpers/widget_tester_extensions.dart';

void main() {
  group('Check image in Widget via Golden tests', () {
    testWidgets(
      'Check image in widget is success and NOT visible',
      (tester) async {
        await tester.pumpWidget(GoldenTestExampleWithImage());

        /// Pump times 160 not worked :(
        await tester.pumpTimes(160);
        await expectLater(
          find.byType(GoldenTestExampleWithImage),

          /// HERE image is alpha equals 0 - check the below file png !!!
          matchesGoldenFile('image_is_not_visible_golden.png'),
        );
      },
    );

    testWidgets(
      'Check image in widget is success and visible',
      (tester) async {
        await tester.pumpWidget(GoldenTestExampleWithImage());

        final Element element = tester.element(find.byType(Image));
        final Image widget = element.widget as Image;

        /// Workaround worked :)
        /// precacheImage
        await precacheImage(widget.image, element);
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(Image),

          /// HERE image is OK - alpha is Good !!!
          matchesGoldenFile('image_is_visible_golden.png'),
        );
      },
    );
  });


}
