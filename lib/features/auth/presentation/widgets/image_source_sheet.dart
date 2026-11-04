import 'package:budgets/core/ui/app_sheet_route.dart';
import 'package:budgets/core/ui/app_sheet_surface.dart';
import 'package:budgets/core/ui/app_sheet_header.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'file_picker_option.dart';

class ImageSourceSheet extends StatelessWidget {
  const ImageSourceSheet({super.key});
  static Future<ImageSource?> show(BuildContext context) =>
      showAppSheet<ImageSource>(context,
          builder: (_) => const ImageSourceSheet());
  @override
  Widget build(BuildContext context) => AppSheetSurface(
      height: 260,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 20, 32, 24),
        child: Column(children: [
          AppSheetHeader(
              title: context.l10n.chooseSource,
              onClose: () => Navigator.pop(context)),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            FileOption(
                icon: Icons.photo_library,
                title: context.l10n.fromGallery,
                onTap: () => Navigator.pop(context, ImageSource.gallery)),
            FileOption(
                icon: Icons.photo_camera,
                title: context.l10n.takePhoto,
                onTap: () => Navigator.pop(context, ImageSource.camera)),
          ]),
        ]),
      ));
}
