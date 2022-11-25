import 'package:flutter/material.dart';

class HelperFunctions {
  static Widget wrapWithAnimatedBuilder({
    required Animation<Offset> animation,
    required Widget child,
  }) {
    return SizedBox(
      width: 600,
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, __) => FractionalTranslation(
          translation: animation.value,
          child: child,
        ),
      ),
    );
  }
}
