part of 'goal_list_item.dart';

extension _GoalListItemStateBuildHeader on _GoalListItemState {
  Widget _buildHeader(
      BuildContext context, WidgetRef ref, double rate, String currencyCode) {
    final goal = widget.goal;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goal.name ?? 'Objectif',
                style: AppTextStyle(AppTextRole.body,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              if (goal.category?.name != null)
                CategoryIconLabel(
                  name: goal.category?.name ?? '',
                  iconKey: goal.category?.iconKey,
                  emoji: goal.category?.emoji,
                  colorHex: goal.category?.color,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  style: AppTextStyle(
                    AppTextRole.supporting,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              if (goal.dateAim != null)
                Text(
                  'D\'ici le ${_formatDate(goal.dateAim!)}',
                  style: AppTextStyle(AppTextRole.body,
                      color: Theme.of(context).hintColor),
                ),
            ],
          ),
        ),
        InkWell(
          onTap: () => _showAddAmountDialog(
            context,
            ref,
            rate,
            currencyCode,
          ),
          child: Icon(
            Icons.add_circle_rounded,
            color: AppIconForeground.resolve(
                context, Theme.of(context).textTheme.bodyMedium?.color),
            size: 20,
          ),
        ),
      ],
    );
  }
}
