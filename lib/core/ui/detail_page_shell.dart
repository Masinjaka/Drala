import 'package:budgets/core/ui/detail_page_header.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/detail_enter_transition.dart';

class DetailPageShell extends StatelessWidget {
  const DetailPageShell(
      {required this.title,
      required this.child,
      this.bottomNavigationBar,
      this.maxWidth = 520,
      this.onAdd,
      super.key});
  final String title;
  final Widget child;
  final Widget? bottomNavigationBar;
  final double maxWidth;
  final VoidCallback? onAdd;
  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          bottom: false,
          child: Center(
              child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(29, 15, 29, 16),
                        child: DetailPageHeader(title: title, onAdd: onAdd)),
                    Expanded(child: DetailEnterTransition(child: child)),
                  ])))),
      bottomNavigationBar: bottomNavigationBar);
}
