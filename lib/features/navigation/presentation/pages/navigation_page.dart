import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'dart:async';

import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/features/navigation/domain/providers/sub_tab_providers.dart';
import 'package:budgets/features/planning/presentation/widgets/add_budget_bottom_sheet.dart';
import 'package:budgets/features/planning/presentation/widgets/add_goal_bottom_sheet.dart';
import 'package:budgets/features/transactions/presentation/widgets/add_transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

part 'navigation_page_layout.dart';
part 'navigation_tab_config.dart';

class NavigatorPage extends ConsumerStatefulWidget {
  const NavigatorPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends ConsumerState<NavigatorPage> {
  final Map<int, bool> _fabVisibilityByTab = {
    _transactionTabIndex: true,
    _planningTabIndex: true,
  };
  final Map<int, ScrollDirection?> _lastDirectionByTab = {};
  Timer? _scrollTimer;

  static const _transactionTabIndex = 1;
  static const _planningTabIndex = 2;

  static const _tabs = [
    _TabConfig(
      label: 'Accueil',
      selectedIcon: FontAwesomeIcons.solidHouse,
      unselectedIcon: FontAwesomeIcons.house,
    ),
    _TabConfig(
      label: 'Transactions',
      selectedIcon: FontAwesomeIcons.solidCreditCard,
      unselectedIcon: FontAwesomeIcons.creditCard,
    ),
    _TabConfig(
      label: 'Planifier',
      selectedIcon: FontAwesomeIcons.solidCalendar,
      unselectedIcon: FontAwesomeIcons.calendar,
    ),
    _TabConfig(
      label: 'Profil',
      selectedIcon: FontAwesomeIcons.solidUser,
      unselectedIcon: FontAwesomeIcons.user,
    ),
  ];

  bool _isFabTab(int index) =>
      index == _transactionTabIndex || index == _planningTabIndex;

  bool _isFabVisibleForTab(int index) => _fabVisibilityByTab[index] ?? true;

  void _setFabVisibleForTab(int index, bool visible) {
    if (!mounted || _isFabVisibleForTab(index) == visible) {
      return;
    }

    setState(() {
      _fabVisibilityByTab[index] = visible;
    });
  }

  bool _onScrollNotification(
    UserScrollNotification notification,
    int currentIndex,
  ) {
    if (!_isFabTab(currentIndex)) {
      return false;
    }

    final direction = notification.direction;
    if (direction == ScrollDirection.idle) {
      _scrollTimer?.cancel();
      _lastDirectionByTab[currentIndex] = null;
      return false;
    }

    if (direction == ScrollDirection.forward &&
        !_isFabVisibleForTab(currentIndex)) {
      _scrollTimer?.cancel();
      _lastDirectionByTab[currentIndex] = null;
      _setFabVisibleForTab(currentIndex, true);
    } else if (direction == ScrollDirection.reverse &&
        _isFabVisibleForTab(currentIndex)) {
      if (direction != _lastDirectionByTab[currentIndex]) {
        _lastDirectionByTab[currentIndex] = direction;
        _scrollTimer?.cancel();
        _scrollTimer = Timer(const Duration(milliseconds: 100), () {
          if (!mounted || widget.navigationShell.currentIndex != currentIndex) {
            return;
          }

          if (_isFabVisibleForTab(currentIndex)) {
            setState(() {
              _fabVisibilityByTab[currentIndex] = false;
            });
          }
        });
      }
    }

    return false;
  }

  void _onFabPressed(int currentIndex) {
    if (currentIndex == _transactionTabIndex) {
      final subTab = ref.read(transactionSubTabProvider);
      final type =
          subTab == 0 ? TransactionType.expense : TransactionType.income;
      AddTransactionDialog.show(context, transactionType: type);
    } else if (currentIndex == _planningTabIndex) {
      final subTab = ref.read(planningSubTabProvider);
      if (subTab == 0) {
        AddBudgetBottomSheet.show(context);
      } else {
        AddGoalBottomSheet.show(context);
      }
    }
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildContent(context);
}
