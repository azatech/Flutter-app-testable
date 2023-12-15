import 'package:flutter/material.dart';

const testImageGolden = 'resources/images/image_golden_test_example.png';

final imageForTest = Image.asset(testImageGolden);

/// 1. Golden test example in widget with png
class GoldenTestExampleWithImage extends StatelessWidget {
  const GoldenTestExampleWithImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return imageForTest;
  }
}

/// 2. Golden test example in Image.asset.
/// Please watch Golden tests in 'test' directory
