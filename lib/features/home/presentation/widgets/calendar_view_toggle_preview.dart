import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'calendar_view_toggle.dart';

@Preview(name: 'Centered calendar toggle', size: Size(340, 100))
Widget calendarViewTogglePreview() {
  var expanded = false;
  return MaterialApp(
    home: Material(
      child: StatefulBuilder(
        builder: (context, setState) => Center(
          child: CalendarViewToggle(
            isExpanded: expanded,
            onPressed: () => setState(() => expanded = !expanded),
          ),
        ),
      ),
    ),
  );
}
