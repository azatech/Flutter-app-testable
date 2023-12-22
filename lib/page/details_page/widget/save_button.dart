import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final bool isActive;
  final Function() onPressed;

  const SaveButton({
    super.key,
    required this.onPressed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !isActive,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              !isActive ? Colors.black.withOpacity(0.52) : null,
            ),
            backgroundColor: MaterialStateProperty.all(
              !isActive ? Colors.grey.withOpacity(0.05) : null,
            ),
          ),
          onPressed: onPressed,
          child: const Text('Save'),
        ),
      ),
    );
  }
}
