import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthCalendarButton extends StatelessWidget {
  const MonthCalendarButton({
    required this.month,
    required this.onPressed,
    required this.buttonKey,
    this.showMonth = false,
    this.maxWidth = 190,
    this.yearKey,
    super.key,
  });

  final DateTime month;
  final VoidCallback onPressed;
  final Key buttonKey;
  final Key? yearKey;
  final bool showMonth;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final fullLabel =
        toBeginningOfSentenceCase(DateFormat.MMMM(locale).format(month));
    final label = maxWidth < 160
        ? toBeginningOfSentenceCase(DateFormat.MMM(locale).format(month))
        : fullLabel;
    return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: AppEnvelopeTheme.radius,
                boxShadow: AppEnvelopeTheme.shadows(context)),
            child: SizedBox(
                height: AppHeaderMetrics.buttonSize,
                child: TextButton(
                    key: buttonKey,
                    onPressed: onPressed,
                    style: AppEnvelopeTheme.yearButton(context),
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: showMonth ? 1 : 0),
                            duration: MediaQuery.disableAnimationsOf(context)
                                ? Duration.zero
                                : const Duration(milliseconds: 240),
                            curve: Curves.easeOutCubic,
                            builder: (context, progress, _) =>
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  const Icon(Icons.calendar_month, size: 16),
                                  const SizedBox(width: 8),
                                  ClipRect(
                                      child: Align(
                                          widthFactor: progress,
                                          child: Offstage(
                                              offstage: progress == 0,
                                              child: Opacity(
                                                  opacity: progress,
                                                  child: Transform.translate(
                                                      offset: Offset(0,
                                                          (1 - progress) * 6),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .only(end: 6),
                                                          child: Text(label,
                                                              semanticsLabel:
                                                                  fullLabel,
                                                              key: const Key(
                                                                  'calendar-button-month')))))))),
                                  Text('${month.year}', key: yearKey),
                                ])))))));
  }
}
