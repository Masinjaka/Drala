import 'package:budgets/core/ui/app_sheet_route.dart';
import 'package:flutter/material.dart';

Future<T?> showTransactionFormSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) =>
    showAppSheet<T>(context, builder: builder);
