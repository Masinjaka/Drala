import 'package:flutter/widgets.dart';

class TransactionFormScrollPhysics extends ScrollPhysics {
  const TransactionFormScrollPhysics({super.parent});

  @override
  TransactionFormScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return TransactionFormScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool get allowUserScrolling => false;

  @override
  bool get allowImplicitScrolling => true;
}
