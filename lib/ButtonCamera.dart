import 'package:flutter/material.dart';

class ButtonCamera extends StatelessWidget {
  const ButtonCamera({super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.lightBlue,
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: const Icon(Icons.camera_alt),
        color: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, '/camera');
        },
      ),
    );
  }
}