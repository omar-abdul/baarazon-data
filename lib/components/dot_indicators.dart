import 'package:flutter/material.dart';

import '../constants.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
    this.inActiveColor,
    this.activeColor = const Color.fromARGB(255, 4, 132, 63),
  });

  final bool isActive;

  final Color? inActiveColor, activeColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: defaultDuration,
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
        color: isActive
            ? activeColor
            : inActiveColor ??
                Theme.of(context).primaryColor.withValues(alpha: .3),
        borderRadius: const BorderRadius.all(Radius.circular(defaultPadding)),
      ),
    );
  }
}
