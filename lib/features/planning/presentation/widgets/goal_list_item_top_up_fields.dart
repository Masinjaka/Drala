part of 'goal_list_item.dart';

extension _GoalListItemTopUpFields on _GoalListItemState {
  Widget _buildTopUpForm(
          BuildContext context,
          BuildContext ctx,
          GlobalKey<FormState> formKey,
          TextEditingController amountController,
          Goal goal,
          double currentAmount,
          double goalAmount,
          String currencyCode) =>
      Form(
          key: formKey,
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 32),
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ajouter à ${goal.name ?? 'l\'objectif'}',
                    style: AppTextStyle(AppTextRole.sheetTitle,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Montant actuel',
                        style: AppTextStyle(AppTextRole.body,
                            color: Theme.of(context).hintColor),
                      ),
                      Text(
                        formatAmountWithCurrency(
                          currentAmount,
                          currencyCode,
                          preserveFraction: true,
                        ),
                        style: AppTextTheme.amount(AppTextStyle(
                            AppTextRole.body,
                            color: Colors.black)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Objectif',
                        style: AppTextStyle(AppTextRole.body,
                            color: Theme.of(context).hintColor),
                      ),
                      Text(
                        formatAmountWithCurrency(
                          goalAmount,
                          currencyCode,
                          preserveFraction: true,
                        ),
                        style: AppTextTheme.amount(AppTextStyle(
                            AppTextRole.body,
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Restant',
                        style: AppTextStyle(AppTextRole.body,
                            color: Theme.of(context).hintColor),
                      ),
                      Text(
                        formatAmountWithCurrency(
                          goalAmount - currentAmount,
                          currencyCode,
                          preserveFraction: true,
                        ),
                        style: AppTextTheme.amount(AppTextStyle(
                            AppTextRole.body,
                            color: Theme.of(context).hintColor)),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Montant à ajouter',
                    style: AppTextStyle(AppTextRole.body,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  SizedBox(height: 8),
                  ValidatedInput(
                      controller: amountController,
                      validator: (value) =>
                          FieldValidators.positiveAmount(context, value),
                      child: AnimatedAmountField(
                        controller: amountController,
                        hint: '0',
                        fontSize: AppTypography.display,
                        height: 80,
                        fillColor: Theme.of(context).colorScheme.surfaceDim,
                        borderRadius: BorderRadius.circular(12),
                      )),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        text: 'Annuler',
                        onPressed: () => Navigator.of(ctx).pop(),
                        backgroundColor: Theme.of(context).cardColor,
                        width: 120,
                        borderColor: Colors.transparent,
                      ),
                      SizedBox(width: 8),
                      CustomButton(
                        text: 'Ajouter',
                        onPressed: () {
                          if (!(formKey.currentState?.validate() ?? false))
                            return;
                          final amount =
                              parseAmountInput(amountController.text);
                          if (amount > 0) {
                            Navigator.of(ctx).pop(amount);
                          }
                        },
                        backgroundColor: Theme.of(context).primaryColor,
                        width: 120,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
}
