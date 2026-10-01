import 'package:flutter/material.dart';

class HomeCalendarTopGap extends StatelessWidget {
  const HomeCalendarTopGap({
    required this.visibility,
    required this.height,
    super.key,
  });

  static const expandedHeight = 4.0;

  final Animation<double> visibility;
  final double height;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: visibility,
        builder: (context, _) => SizedBox(
          key: const Key('home-calendar-top-gap'),
          height: height - (height - expandedHeight) * visibility.value,
        ),
      );
}
