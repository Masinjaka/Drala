import 'package:flutter/material.dart';

class HomeCalendarActivityMarker extends StatelessWidget {
  const HomeCalendarActivityMarker({this.size = 8, super.key});

  static const color = Color(0xFF12BC8B);

  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: SizedBox.square(
          key: const Key('home-calendar-activity-marker'),
          dimension: size,
          child: const DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      );
}
