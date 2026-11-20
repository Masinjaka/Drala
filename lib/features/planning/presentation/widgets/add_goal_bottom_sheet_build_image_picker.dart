part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStateBuildImagePicker on _AddGoalBottomSheetState {
  Widget _buildImagePicker() {
    final imageSize = 96.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Image',
          style: AppTextStyle(AppTextRole.body,
              color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).hintColor.withAlpha(75),
                style: BorderStyle.solid,
              ),
            ),
            child: _imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _imagePath!.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: _imagePath!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const Center(child: AppLoader(size: 42)),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Image.file(
                            File(_imagePath!),
                            fit: BoxFit.cover,
                          ),
                  )
                : Center(
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: AppIconForeground.resolve(
                          context, Theme.of(context).hintColor),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
