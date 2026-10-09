import 'package:flutter/material.dart';

import 'setup_choice_content.dart';
import 'setup_choices_skeleton.dart';
import 'setup_completion.dart';
import 'setup_currency_choices.dart';
import 'setup_delayed_content.dart';
import 'setup_header.dart';
import 'setup_page_layout.dart';

class SetupPageView extends StatelessWidget {
  const SetupPageView({
    required this.controller,
    required this.activeStep,
    required this.initialStep,
    required this.titles,
    required this.bodies,
    required this.completionTitle,
    required this.completionBody,
    required this.language,
    required this.currency,
    required this.categories,
    required this.wallets,
    required this.onBack,
    required this.onLanguageChanged,
    required this.onCurrencyChanged,
    required this.onCategoryChanged,
    required this.onWalletChanged,
    super.key,
  });

  final PageController controller;
  final int activeStep;
  final int initialStep;
  final List<String> titles;
  final List<String> bodies;
  final String completionTitle;
  final String completionBody;
  final String language;
  final String currency;
  final Set<String> categories;
  final Set<String> wallets;
  final VoidCallback onBack;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onCurrencyChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onWalletChanged;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) => SetupHeader(
              currentStep: controller.hasClients
                  ? (controller.page ?? controller.initialPage).round() + 2
                  : activeStep,
              onBack: activeStep > 2 && activeStep < 6 ? onBack : null,
              showDisabledBack: activeStep == 6,
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) => _page(index),
            ),
          ),
        ],
      );

  Widget _page(int index) {
    if (index == 4) {
      if (activeStep != 6) return const SizedBox.shrink();
      return SetupCompletion(
        title: completionTitle,
        subtitle: completionBody,
        entranceDelay: _delay(6),
      );
    }
    final pageStep = index + 2;
    return SetupPageLayout(
      title: titles[index],
      subtitle: bodies[index],
      content: activeStep != pageStep
          ? const SizedBox.shrink()
          : SetupDelayedContent(
              delay: _delay(pageStep),
              placeholder: _placeholder(index),
              child: _choices(index),
            ),
    );
  }

  Duration _delay(int step) =>
      Duration(milliseconds: step == initialStep ? 400 : 100);

  Widget _placeholder(int index) => switch (index) {
        0 => const SetupChoicesSkeleton.language(),
        2 => const SetupChoicesSkeleton.categories(),
        3 => const SetupChoicesSkeleton.wallets(),
        _ => const SizedBox.shrink(),
      };

  Widget _choices(int index) => index == 1
      ? SetupCurrencyChoices(
          selected: currency,
          onChanged: onCurrencyChanged,
        )
      : SingleChildScrollView(
          child: SetupChoiceContent(
            step: index + 2,
            language: language,
            categories: categories,
            wallets: wallets,
            onLanguageChanged: onLanguageChanged,
            onCategoryChanged: onCategoryChanged,
            onWalletChanged: onWalletChanged,
          ),
        );
}
