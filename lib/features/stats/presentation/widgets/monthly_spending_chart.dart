import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class MonthlySpendingChart extends StatelessWidget {
  const MonthlySpendingChart({required this.values, super.key});

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    final maximum =
        values.fold<int>(0, (max, value) => value > max ? value : max);
    return Container(
      height: 215,
      padding: const EdgeInsets.fromLTRB(24, 27, 13, 2),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Theme.of(context).colorScheme.onSurface),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.dailySpending,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < values.length; index++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: maximum == 0
                                    ? 0.02
                                    : (values[index] / maximum).clamp(0.02, 1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: values[index] == 0
                                        ? Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withValues(alpha: .28)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            index == 0 || (index + 1) % 5 == 0
                                ? '${index + 1}'
                                : '',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
