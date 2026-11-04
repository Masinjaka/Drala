part of 'add_category_page.dart';

extension _AddCategoryNameAndEmoji on _AddCategoryPageState {
  Widget _nameCard(BuildContext context) => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: CustomTextField(
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              const Icon(
                Icons.edit,
              ),
              Text(
                'Nom',
                textAlign: TextAlign.left,
                style: AppTextStyle(AppTextRole.body),
              ),
            ],
          ),
          hint: 'Entre le nom de ta catégorie',
          controller: _categoryNameController,
          validator: const {
            'type': 'required',
            'error': 'Le nom de la catégorie est requis',
          },
        ),
      );

  Widget _emojiCard(BuildContext context) => Container(
        height: 112,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child: CustomTextField(
                    title: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        const Icon(
                          Icons.emoji_emotions,
                        ),
                        Text(
                          'Emoji',
                          textAlign: TextAlign.left,
                          style: AppTextStyle(AppTextRole.body),
                        ),
                      ],
                    ),
                    hint: 'Choisis un emoji pour ta catégorie',
                    controller: _emoticonController,
                    isReadOnly: true,
                    onTap: () {
                      _showEmojiPicker(context);
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    _showEmojiPicker(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CategoryIcon(
                          emoji: _selectedEmoji,
                          size: 22,
                          colorHex:
                              _selectedColor?.toARGB32().toRadixString(16)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
