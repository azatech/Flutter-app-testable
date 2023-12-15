// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../integration_test/helpers/material_wrapper.dart';

void main() {
  group('Test text button', () {
    testWidgets(
      'Check text button via Golden tests',
      (tester) async {
        await tester.pumpWidget(
          MaterialWrapper(
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 22,
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text('Golden is FIRE!!!'),
              ),
            ),
          ),
        );

        await expectLater(
          find.byType(TextButton),
          matchesGoldenFile('text_button_golden_test.png'),
        );
        await expectLater(
          find.byType(Padding).first,
          matchesGoldenFile('padding_golden_test.png'),
        );
      },
    );
  });
}
