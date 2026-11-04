import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_text_theme.dart';

class SetupPageLayout extends StatelessWidget {
  const SetupPageLayout({
    required this.title,
    required this.subtitle,
    required this.content,
    this.language = false,
    this.scrollBody = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget content;
  final bool language;
  final bool scrollBody;
  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 700 ||
        MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final heading = <Widget>[
      Text(
        title,
        textAlign: TextAlign.start,
        style: AppTextTheme.setupTitle(context),
      ),
      SizedBox(height: compact ? 12 : 29),
      Text(
        subtitle,
        textAlign: TextAlign.start,
        style: language
            ? AppTextTheme.setupBody(context)
            : AppTextTheme.setupSelectionBody(context),
      ),
      SizedBox(height: compact ? 12 : 33),
    ];
    return Padding(
      padding: AppPageSpacing.insets(context, top: 0, bottom: 0),
      child: compact && scrollBody
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [...heading, content],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [...heading, Expanded(child: content)],
            ),
    );
  }
}
