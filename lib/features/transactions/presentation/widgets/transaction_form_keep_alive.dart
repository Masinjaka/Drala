import 'package:flutter/widgets.dart';

/// Preserves form state and picker callbacks while an auxiliary page is open.
class TransactionFormKeepAlive extends StatefulWidget {
  const TransactionFormKeepAlive({required this.child, super.key});

  final Widget child;

  @override
  State<TransactionFormKeepAlive> createState() =>
      _TransactionFormKeepAliveState();
}

class _TransactionFormKeepAliveState extends State<TransactionFormKeepAlive>
    with AutomaticKeepAliveClientMixin<TransactionFormKeepAlive> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
