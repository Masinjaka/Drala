part of 'add_category_page.dart';

extension _AddCategoryEmojiPicker on _AddCategoryPageState {
  void _showEmojiPicker(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    showAppSheet(
      context,
      builder: (sheetCtx) => AppSheetSurface(
        height: 440,
        child: Container(
          height: 440,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: EmojiPicker(
              config: Config(
                searchViewConfig: SearchViewConfig(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  buttonIconColor:
                      Theme.of(context).iconTheme.color ?? Colors.white,
                  hintText: 'Rechercher un emoji',
                  hintTextStyle: AppTextStyle(AppTextRole.input,
                      color: Theme.of(context).hintColor),
                  inputTextStyle: AppTextStyle(AppTextRole.input,
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                categoryViewConfig: CategoryViewConfig(
                  backgroundColor: Theme.of(context).cardColor,
                  tabBarHeight: 56,
                  iconColor: Theme.of(context).iconTheme.color ?? Colors.white,
                  iconColorSelected:
                      Theme.of(context).iconTheme.color ?? Colors.white,
                  backspaceColor:
                      Theme.of(context).iconTheme.color ?? Colors.white,
                  indicatorColor: Theme.of(context).primaryColor,
                ),
                emojiViewConfig: EmojiViewConfig(
                  gridPadding: EdgeInsets.symmetric(horizontal: 8),
                  buttonMode: ButtonMode.CUPERTINO,
                  columns: 5,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  emojiSizeMax: 20,
                ),
                bottomActionBarConfig: BottomActionBarConfig(
                  customBottomActionBar: (config, state, showSearchView) {
                    return Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => showSearchView(),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {},
                                color: Theme.of(context).hintColor,
                              ),
                              Text(
                                'Rechercher',
                                style: AppTextStyle(AppTextRole.body,
                                    color: Theme.of(context).hintColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  buttonColor: Theme.of(context).dividerColor,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  showBackspaceButton: false,
                ),
              ),
              onEmojiSelected: (category, emoji) async {
                Navigator.pop(sheetCtx);

                await Future.delayed(const Duration(milliseconds: 100));
                _update(() {
                  _selectedEmoji = emoji.emoji;
                  _emoticonController.text = _selectedEmoji == null
                      ? 'Choisis un emoji pour ta catégorie'
                      : 'Choisir un autre emoji';
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
