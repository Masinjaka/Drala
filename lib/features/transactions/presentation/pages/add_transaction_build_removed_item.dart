part of 'add_transaction.dart';

extension _TransactionCreationPageStateBuildRemovedItem
    on _TransactionCreationPageState {
  Widget _buildRemovedItem(Map<String, dynamic> item, Animation<double> anim) {
    return SizeTransition(
      sizeFactor: anim.drive(Tween(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut))),
      child: ScaleTransition(
        scale: anim.drive(Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut))),
        child: FadeTransition(
            opacity: anim,
            child: SubcategoryAmountRow(
                item: item, subcategories: _subcategories, enabled: false)),
      ),
    );
  }
}
