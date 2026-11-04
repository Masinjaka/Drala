import 'package:budgets/core/ui/sliding_tab_indicator.dart';
import 'package:budgets/core/ui/app_category_theme.dart';
import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

/// A finite, two-choice companion to the envelope month carousel.
class CategoryTypeCarousel extends StatelessWidget {
  const CategoryTypeCarousel({required this.controller, super.key});
  final TabController controller;

  void _select(int index) => controller.animateTo(index,
      duration: SlidingTabIndicator.duration, curve: SlidingTabIndicator.curve);

  @override
  Widget build(BuildContext context) {
    final scaled = MediaQuery.textScalerOf(context).scale(14);
    final height = 50 + (scaled - 14).clamp(0.0, double.infinity) * 2.6;
    var dragDistance = 0.0;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Center(
      child: Container(
        key: const Key('category-type-carousel'),
        width: 281,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppEnvelopeTheme.surface(context),
          borderRadius: AppEnvelopeTheme.radius,
          boxShadow: AppEnvelopeTheme.shadows(context),
        ),
        child: GestureDetector(
          onHorizontalDragStart: (_) => dragDistance = 0,
          onHorizontalDragUpdate: (details) => dragDistance += details.delta.dx,
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity ?? 0;
            if (dragDistance.abs() < 24 && velocity.abs() < 80) return;
            final delta = dragDistance.abs() >= 24 ? dragDistance : velocity;
            final forward = rtl ? delta > 0 : delta < 0;
            _select((controller.index + (forward ? 1 : -1)).clamp(0, 1));
          },
          child: AnimatedBuilder(
            animation: controller.animation!,
            builder: (context, _) {
              return Stack(children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SlidingTabIndicator(
                        animation: controller.animation!,
                        count: 2,
                        color: AppCategoryTheme.selectedBackground(context),
                        radius: AppEnvelopeTheme.radius),
                  ),
                ),
                Row(children: [
                  for (var index = 0; index < 2; index++)
                    Expanded(
                      child: Semantics(
                        button: true,
                        selected: controller.index == index,
                        child: InkWell(
                          onTap: () => _select(index),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                index == 0
                                    ? context.l10n.expense
                                    : context.l10n.income,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: AppCategoryTheme.tab(context,
                                    selected: controller.index == index),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ]),
              ]);
            },
          ),
        ),
      ),
    );
  }
}
