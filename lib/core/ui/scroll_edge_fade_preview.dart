import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'scroll_edge_fade.dart';

@Preview(name: 'Scroll edge fades', size: Size(360, 500))
Widget scrollEdgeFadePreview() => MaterialApp(
      home: Scaffold(
        body: ScrollEdgeFade(
          child: ListView.builder(
            itemCount: 30,
            itemBuilder: (context, index) => ListTile(
              leading: const Icon(Icons.receipt_outlined),
              title: Text('Transaction ${index + 1}'),
              subtitle: const Text('Shopping'),
              trailing: const Text('3 990 MGA'),
            ),
          ),
        ),
      ),
    );
