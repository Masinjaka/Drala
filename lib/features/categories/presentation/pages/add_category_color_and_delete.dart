part of 'add_category_page.dart';

extension _AddCategoryColorAndDelete on _AddCategoryPageState {
  Widget _colorCard(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.color_lens,
                    ),
                    Text(
                      "Choisis la couleur de fond de ta catégorie",
                      textAlign: TextAlign.left,
                      style: AppTextStyle(AppTextRole.body),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Center(
                child: ColorPicker(
                  color: _selectedColor ?? Colors.teal,
                  onColorChanged: (Color color) {
                    // String colortest = color.value.toRadixString(16);
                    // int colorInt = int.parse(colortest, radix: 16);
                    // debugPrint('Selected color: $colortest');
                    _update(() => _selectedColor = color);
                  },
                  pickersEnabled: const <ColorPickerType, bool>{
                    ColorPickerType.wheel: true,
                    ColorPickerType.accent: false,
                    ColorPickerType.primary: false,
                    ColorPickerType.both: true,
                    ColorPickerType.custom: true,
                    ColorPickerType.bw: false,
                  },
                  wheelDiameter: 200,
                  wheelWidth: 16,
                  wheelHasBorder: false,
                  enableShadesSelection: false,
                  columnSpacing: 24,
                  wheelSquarePadding: 8,
                  pickerTypeLabels: const <ColorPickerType, String>{
                    ColorPickerType.wheel: 'Personnalisé',
                    ColorPickerType.accent: 'Accent',
                    ColorPickerType.primary: 'Primaire',
                    ColorPickerType.both: 'Basique',
                    ColorPickerType.custom: 'Personnalisé',
                    ColorPickerType.bw: 'N&B',
                  },
                  pickerTypeTextStyle: AppTextStyle(AppTextRole.body,
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
              ),
            ),
          ],
        ),
      );
}
