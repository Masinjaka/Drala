part of 'goal_list_item.dart';

extension _GoalListItemStateBuild on _GoalListItemState {
  Widget _buildFormContent(BuildContext context) {
    final goal = widget.goal;
    final cardBorderRadius = BorderRadius.circular(16);
    final currencyState = ref.watch(currencyControllerProvider).value;
    final currencyCode = currencyState?.code ?? 'MGA';
    final rate = currencyState?.rateFor(currencyCode) ?? 1.0;
    final hasNetworkImage = goal.imagePath != null &&
        goal.imagePath!.isNotEmpty &&
        goal.imagePath!.startsWith('http');
    final goalAmountMga = parseAmountInput(goal.goalAmount ?? '0');
    final currentAmountMga = parseAmountInput(goal.currentAmount ?? '0');
    final goalAmount = convertFromMga(goalAmountMga, rate);
    final currentAmount = convertFromMga(currentAmountMga, rate);
    final progress = goalAmountMga > 0
        ? (currentAmountMga / goalAmountMga).clamp(0.0, 1.0)
        : 0.0;

    final card = Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: cardBorderRadius,
        clipBehavior: Clip.antiAlias,
        child: Slidable(
          controller: _slidableController,
          key: Key(goal.id ?? DateTime.now().toString()),
          enabled: !_isDismissing,
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: _GoalListItemState._deletePaneExtentRatio,
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
            color: Theme.of(context).colorScheme.surface,
            borderRadius: cardBorderRadius,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  margin: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (hasNetworkImage)
                          CachedNetworkImage(
                            imageUrl: goal.imagePath!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor:
                                  Theme.of(context).colorScheme.surfaceDim,
                              highlightColor: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withValues(alpha: 0.9),
                              direction: ShimmerDirection.ltr,
                              period: 1000.ms,
                              child: Container(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/image-placeholder.png',
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Image.asset(
                            'assets/images/image-placeholder.png',
                            fit: BoxFit.cover,
                          ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: _isDismissing
                                ? null
                                : () => _showEditDialog(context),
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: Icon(
                                Icons.edit,
                                color: AppIconForeground.resolve(
                                    context,
                                    Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color),
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, ref, rate, currencyCode),
                      SizedBox(height: 8),
                      _buildAmountRow(
                        context,
                        currentAmount,
                        goalAmount,
                        currencyCode,
                      ),
                      SizedBox(height: 8),
                      PlanningProgressBar(progress: progress),
                      SizedBox(height: 4),
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}% atteint',
                        style: AppTextStyle(AppTextRole.body,
                            color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ),
              ],
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
      duration: _GoalListItemState._dismissDuration,
      curve: Curves.easeOutCubic,
      offset: _isDismissing ? const Offset(0.15, 0) : Offset.zero,
      child: AnimatedOpacity(
        duration: _GoalListItemState._dismissDuration,
        curve: Curves.easeOut,
        opacity: _isDismissing ? 0 : 1,
        child: AnimatedSize(
          duration: _GoalListItemState._dismissDuration,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _isDismissing ? const SizedBox.shrink() : animatedEntry,
        ),
      ),
    );
  }
}
