import 'package:flutter/material.dart';

class MaterialWrapper extends StatelessWidget {
  const MaterialWrapper(
    this.testWidget, {
    super.key,
  });

  final Widget testWidget;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: testWidget,
    );
  }
}
