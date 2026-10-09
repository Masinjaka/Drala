import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/features/onboarding/domain/models/onboarding_preset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budgets/widgets/custom_button.dart';
import '../../domain/providers/onboarding_providers.dart';
import 'setup_category_icon.dart';
import 'setup_choices_skeleton.dart';
import 'setup_grid_choice.dart';

class SetupPresetChoices extends ConsumerWidget {
  const SetupPresetChoices(
      {required this.language,
      required this.selected,
      required this.onChanged,
      super.key});
  final String language;
  final Set<String> selected;
  final ValueChanged<String> onChanged;

  static const visible = [
    'shopping',
    'transport',
    'health',
    'utilities',
    'food',
    'entertainment',
    'salary',
    'freelance',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(onboardingPresetsProvider).when(
          loading: () => const SetupChoicesSkeleton.categories(),
          error: (_, __) => Column(children: [
            Text(context.l10n.setupLoadError),
            CustomButton.text(
              text: context.l10n.setupRetry,
              onPressed: () => ref.invalidate(onboardingPresetsProvider),
            )
          ]),
          data: (presets) {
            final ordered = presets
                .where((item) => visible.contains(item.slug))
                .toList()
              ..sort((a, b) =>
                  visible.indexOf(a.slug).compareTo(visible.indexOf(b.slug)));
            final expenses =
                ordered.where((item) => item.type != 'income').toList();
            final incomes =
                ordered.where((item) => item.type == 'income').toList();
            return LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 10) / 2;
                final cardHeight = _largestCardHeight(
                  context,
                  ordered,
                  cardWidth,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    Text(context.l10n.expenses,
                        style: AppTextTheme.onboardingLabel(context)),
                    const SizedBox(height: 27),
                    _grid(context, expenses, cardHeight),
                    const SizedBox(height: 24),
                    Text(context.l10n.income,
                        style: AppTextTheme.onboardingLabel(context)),
                    const SizedBox(height: 27),
                    _grid(context, incomes, cardHeight),
                  ],
                );
              },
            );
          },
        );
  }

  double _largestCardHeight(
    BuildContext context,
    List<OnboardingPreset> presets,
    double cardWidth,
  ) {
    final textWidth = (cardWidth - 74).clamp(1.0, double.infinity).toDouble();
    final style = AppTextTheme.onboardingLabel(context);
    final textScaler = MediaQuery.textScalerOf(context);
    var maxTextHeight = 0.0;
    for (final preset in presets) {
      final painter = TextPainter(
        text: TextSpan(text: preset.nameFor(language), style: style),
        textDirection: Directionality.of(context),
        textScaler: textScaler,
      )..layout(maxWidth: textWidth);
      if (painter.height > maxTextHeight) maxTextHeight = painter.height;
    }
    return (maxTextHeight + 16).clamp(40.0, double.infinity).toDouble();
  }

  Widget _grid(
    BuildContext context,
    List<OnboardingPreset> presets,
    double cardHeight,
  ) =>
      LayoutBuilder(builder: (context, constraints) {
        final width = (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var index = 0; index < presets.length; index++)
              SizedBox(
                width: width,
                child: SetupGridChoice(
                  title: presets[index].nameFor(language),
                  height: cardHeight,
                  selected: selected.contains(presets[index].slug),
                  leading: SetupCategoryIcon(iconKey: presets[index].icon),
                  onTap: () => onChanged(presets[index].slug),
                ).animate(delay: (50 * index).ms).fade(duration: 200.ms).slideY(
                      begin: 0.5,
                      duration: 200.ms,
                      curve: Curves.easeOut,
                    ),
              ),
          ],
        );
      });
}
