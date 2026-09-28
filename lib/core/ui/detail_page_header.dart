import 'package:budgets/core/ui/outlined_square_button.dart';
import 'package:flutter/material.dart';

class DetailPageHeader extends StatelessWidget {
  const DetailPageHeader({
    required this.title,
    this.onAdd,
    this.addTooltip,
    super.key,
  });

  final String title;
  final VoidCallback? onAdd;
  final String? addTooltip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedSquareButton(
          icon: Icons.arrow_back_rounded,
          onPressed: () => Navigator.maybePop(context),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        if (onAdd != null)
          OutlinedSquareButton(
            key: const Key('detail-add-button'),
            icon: Icons.add_rounded,
            onPressed: onAdd!,
            tooltip: addTooltip,
          ),
      ],
    );
  }
}
