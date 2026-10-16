import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class CategoryEmojiPicker extends StatelessWidget {
  const CategoryEmojiPicker({super.key});

  static Future<String?> show(BuildContext context) =>
      showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const CategoryEmojiPicker(),
      );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: SizedBox(
        height: 400,
        child: EmojiPicker(
          config: Config(
            emojiViewConfig: EmojiViewConfig(
              backgroundColor: colors.surfaceContainerLowest,
            ),
            categoryViewConfig: CategoryViewConfig(
              backgroundColor: colors.surfaceContainer,
              iconColor:
                  AppIconForeground.resolve(context, colors.onSurfaceVariant),
              iconColorSelected:
                  AppIconForeground.resolve(context, colors.onSurface),
              backspaceColor:
                  AppIconForeground.resolve(context, colors.onSurface),
              indicatorColor: colors.primary,
            ),
            searchViewConfig: SearchViewConfig(
              backgroundColor: colors.surfaceContainerLowest,
              buttonIconColor:
                  AppIconForeground.resolve(context, colors.onSurface),
              hintTextStyle: Theme.of(context).textTheme.bodySmall,
              inputTextStyle: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          onEmojiSelected: (_, emoji) => Navigator.of(context).pop(emoji.emoji),
        ),
      ),
    );
  }
}
