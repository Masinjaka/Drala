part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStateBuild on _AddGoalBottomSheetState {
  Widget _buildFormContent(BuildContext context) {
    return Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AppSheetSurface(
            heightFactor: .86,
            keyboardAware: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSheetHeader(
                        title: _isEditing
                            ? 'Modifier l’objectif'
                            : 'Nouvel objectif',
                        onClose: () => Navigator.of(context).pop(false)),
                    SizedBox(height: 12.8),
                    _buildStepIndicator(),
                    SizedBox(height: 16),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      height: _currentStep == 0 ? 192 : 376,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (index) {
                          if (!mounted) return;
                          _update(() => _currentStep = index);
                        },
                        children: [
                          _buildStepOne(),
                          _buildStepTwo(),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    if (_currentStep == 0)
                      CustomButton(
                        backgroundColor: AppFinanceSurfaceTheme.action(context),
                        foregroundColor:
                            AppFinanceSurfaceTheme.onAction(context),
                        text: 'Suivant',
                        onPressed: _goToNextStep,
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 49.6,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    await _pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 220),
                                      curve: Curves.easeOutCubic,
                                    );
                                  },
                                  splashRadius: 18,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    Icons.chevron_left,
                                    size: 25,
                                    color: AppIconForeground.resolve(
                                        context,
                                        Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            flex: 5,
                            child: CustomButton(
                              backgroundColor:
                                  AppFinanceSurfaceTheme.action(context),
                              foregroundColor:
                                  AppFinanceSurfaceTheme.onAction(context),
                              text: _isEditing ? 'Modifier' : 'Ajouter',
                              onPressed: _saveGoal,
                              isLoading: _isLoading,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
