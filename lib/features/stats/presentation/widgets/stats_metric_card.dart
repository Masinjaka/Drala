import 'package:budgets/core/ui/privacy_text.dart';
import 'package:flutter/material.dart';

class StatsMetricCard extends StatelessWidget {
  const StatsMetricCard({
    required this.label,
    required this.value,
    required this.emoji,
    this.valueColor,
    this.maskValue = true,
    super.key,
  });

  final String label;
  final String value;
  final String emoji;
  final Color? valueColor;
  final bool maskValue;

  @override
  Widget build(BuildContext context) {
    final valueStyle = TextStyle(
      color: valueColor,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    );
    return Container(
      height: 160,
      padding: const EdgeInsets.fromLTRB(17, 19, 17, 20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSurface),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              Text(emoji, style: const TextStyle(fontSize: 20)),
            ],
          ),
          const Spacer(),
          if (maskValue)
            PrivacyText(value, style: valueStyle)
          else
            Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
