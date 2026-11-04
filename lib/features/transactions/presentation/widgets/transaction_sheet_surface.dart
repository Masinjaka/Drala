import 'reference_transaction_surface.dart';
import 'package:flutter/material.dart';

class TransactionSheetSurface extends StatelessWidget {
  const TransactionSheetSurface(
      {super.key,
      required this.pageController,
      required this.pages,
      this.referenceStyle = true});
  final PageController pageController;
  final List<Widget> pages;
  final bool referenceStyle;
  @override
  Widget build(BuildContext context) =>
      ReferenceTransactionSurface(controller: pageController, pages: pages);
}
