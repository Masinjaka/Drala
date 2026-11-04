import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SetupChoicesSkeleton extends StatelessWidget {
  const SetupChoicesSkeleton.language({super.key}) : _layout = 0;
  const SetupChoicesSkeleton.categories({super.key}) : _layout = 1;
  const SetupChoicesSkeleton.wallets({super.key}) : _layout = 2;

  final int _layout;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final content = switch (_layout) {
      0 => _languageRows(context),
      1 => _categoryGrid(context),
      _ => _walletGrid(context),
    };
    return ExcludeSemantics(
      child: MediaQuery.disableAnimationsOf(context)
          ? content
          : Shimmer.fromColors(
              period: const Duration(milliseconds: 1100),
              baseColor: colors.surfaceBright,
              highlightColor: colors.surfaceContainerHigh,
              child: content,
            ),
    );
  }

  Widget _languageRows(BuildContext context) => Column(
        children: [
          for (var index = 0; index < 4; index++) ...[
            _languageRow(context),
            if (index < 3) const SizedBox(height: 10),
          ],
        ],
      );

  Widget _languageRow(BuildContext context) => Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: _decoration(context).copyWith(
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: _bar(context, width: 112, height: 12),
      );

  Widget _categoryGrid(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _bar(context, width: 86, height: 14),
          const SizedBox(height: 11),
          _grid(context, itemCount: 6, height: 50),
          const SizedBox(height: 24),
          _bar(context, width: 64, height: 14),
          const SizedBox(height: 8),
          _grid(context, itemCount: 2, height: 50),
        ],
      );

  Widget _walletGrid(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 32),
        child: _grid(context, itemCount: 3, height: 50),
      );

  Widget _grid(
    BuildContext context, {
    required int itemCount,
    required double height,
  }) =>
      LayoutBuilder(
        builder: (context, constraints) {
          final width = (constraints.maxWidth - 10) / 2;
          return Wrap(
            spacing: 10,
            runSpacing: 7,
            children: [
              for (var index = 0; index < itemCount; index++)
                SizedBox(
                  width: width,
                  height: height,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: _decoration(context),
                    child: Row(
                      children: [
                        _circle(context, 30),
                        const SizedBox(width: 4),
                        Expanded(child: _bar(context, height: 12)),
                        const SizedBox(width: 4),
                        _circle(context, 18),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      );

  BoxDecoration _decoration(BuildContext context) => BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(999),
      );

  Widget _bar(BuildContext context, {double? width, required double height}) =>
      Container(
        width: width,
        height: height,
        decoration: _decoration(context),
      );

  Widget _circle(BuildContext context, double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceBright,
          shape: BoxShape.circle,
        ),
      );
}
