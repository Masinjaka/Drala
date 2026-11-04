import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/currency/currency_state.dart';

class FormCurrencyController extends CurrencyController {
  @override
  Future<CurrencyState> build() async =>
      const CurrencyState(code: 'MGA', baseCode: 'MGA', rates: {'MGA': 1});
}
