part of 'budget_list_item.dart';

extension _BudgetListItemLayout on _BudgetListItemState {
  Widget _buildContent(BuildContext context) {
    final budget = widget.budget;
    final cardBorderRadius = BorderRadius.circular(16);
    final currencyState = ref.watch(currencyControllerProvider).value;
    final currencyCode = currencyState?.code ?? 'MGA';
    final rate = currencyState?.rateFor(currencyCode) ?? 1.0;
    final category = budget.category;
    final amountMga = double.tryParse(budget.amount ?? '0') ?? 0;
    final spentMga = double.tryParse(budget.amountSpent ?? '0') ?? 0;
    final amount = convertFromMga(amountMga, rate);
    final spent = convertFromMga(spentMga, rate);
    final progress = amount > 0 ? (spent / amount).clamp(0.0, 1.0) : 0.0;

    final card = Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: cardBorderRadius,
        clipBehavior: Clip.antiAlias,
        child: Slidable(
          controller: _slidableController,
          key: Key(budget.id?.toString() ?? DateTime.now().toString()),
          enabled: !_isDismissing,
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: _BudgetListItemState._deletePaneExtentRatio,
            children: [
              CustomSlidableAction(
                autoClose: false,
                padding: EdgeInsets.only(left: 4),
                backgroundColor: Colors.transparent,
                onPressed: (_) => _handleDeleteAction(),
                child: SizedBox.expand(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Icon(
                          Icons.delete,
                          color: AppDangerTheme.onFill,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ).animate(target: _swipeProgress).custom(
                      duration: 120.ms,
                      curve: Curves.linear,
                      builder: (context, value, child) => DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppDangerTheme.fill,
                          borderRadius: cardBorderRadius,
                        ),
                        child: child,
                      ),
                    ),
              ),
            ],
          ),
          child: Material(
            color: Theme.of(context).cardColor,
            borderRadius: cardBorderRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              borderRadius: cardBorderRadius,
              onTap: _isDismissing ? null : () => _showEditDialog(context),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              child: Center(
                                child: CategoryIcon(
                                    iconKey: category?.iconKey,
                                    emoji: category?.emoji,
                                    colorHex: category?.color,
                                    size: 18,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceDim),
                              ),
                            ),
                            Text(
                              category?.name ?? 'Catégorie inconnue',
                              style: AppTextStyle(AppTextRole.body,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${formatAmountWithCurrency(spent, currencyCode, preserveFraction: true)} / ${formatAmountWithCurrency(amount, currencyCode, preserveFraction: true)}',
                              style: AppTextTheme.amount(AppTextStyle(
                                  AppTextRole.body,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color)),
                            ),
                            SizedBox(height: 3.2),
                            Text(
                              _periodLabel(budget.period),
                              style: AppTextStyle(AppTextRole.supporting,
                                  color: Theme.of(context).hintColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    PlanningProgressBar(
                        progress: progress, useWarningColors: true),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final animatedEntry = card
        .animate(delay: (50 * widget.index).ms)
        .fade(duration: 200.ms)
        .slideY(begin: 0.3, duration: 200.ms, curve: Curves.easeOut);

    return AnimatedSlide(
      duration: _BudgetListItemState._dismissDuration,
      curve: Curves.easeOutCubic,
      offset: _isDismissing ? const Offset(0.15, 0) : Offset.zero,
      child: AnimatedOpacity(
        duration: _BudgetListItemState._dismissDuration,
        curve: Curves.easeOut,
        opacity: _isDismissing ? 0 : 1,
        child: AnimatedSize(
          duration: _BudgetListItemState._dismissDuration,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _isDismissing ? const SizedBox.shrink() : animatedEntry,
        ),
      ),
    );
  }
}
