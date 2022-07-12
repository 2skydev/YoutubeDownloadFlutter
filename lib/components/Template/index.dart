import 'package:flutter/material.dart';

class Template extends StatelessWidget {
  Widget child;

  Template({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: child,
    );
  }
}
