import 'package:budgets/core/layout/app_scroll_padding.dart';
import 'package:budgets/core/navigation/app_modal_page_route.dart';
import 'dart:io';

import 'package:budgets/core/functions/pick_image_with_permissions.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/settings/presentation/modules/edit_profile_module.dart';
import 'package:budgets/features/settings/presentation/widgets/editable_profile_avatar.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_shell.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_transaction_field.dart';
import 'package:budgets/features/user/domain/provider/user_providers.dart';
import 'package:budgets/features/user/presentation/controllers/username_controller.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  static Future<void> show(BuildContext context) =>
      Navigator.of(context).push<void>(AppModalPageRoute(
        builder: (_) => const EditProfilePage(),
      ));

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _module = EditProfileModule();
  File? _selectedImage;
  String? _profilePhotoUrl;
  bool _loadingPhoto = true;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    ref.read(userModelProvider.future).then((user) {
      if (!mounted) return;
      setState(() {
        _profilePhotoUrl = user?.profilePhoto;
        _usernameController.text = user?.name ?? '';
        _loadingPhoto = false;
      });
    }).catchError((_) {
      if (mounted) setState(() => _loadingPhoto = false);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(usernameControllerProvider, (_, next) {
      next.whenOrNull(error: (error, _) => showErrorToast(context, error));
    });
    final form = Form(
      key: _formKey,
      child: ListView(
        padding: AppScrollPadding.insets(context, top: 24, bottom: 32),
        children: [
          EditableProfileAvatar(
            selectedImage: _selectedImage,
            photoUrl: _profilePhotoUrl,
            isLoading: _loadingPhoto,
            onTap: _pickImage,
          ),
          const SizedBox(height: 30),
          SettingsTransactionField(
            label: context.l10n.username,
            hint: context.l10n.enterUsername,
            controller: _usernameController,
            validator: const {'type': 'required'},
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: context.l10n.save,
            height: 40,
            isLoading: _updating,
            onPressed: _updating ? null : _save,
          ),
        ],
      ),
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SettingsPageShell(title: context.l10n.editProfile, child: form),
    );
  }

  Future<void> _pickImage() async {
    final file = await pickImageWithPermissions(context);
    if (file != null && mounted) setState(() => _selectedImage = file);
  }

  Future<void> _save() async {
    setState(() => _updating = true);
    try {
      await _module.updateProfile(
        context: context,
        formKey: _formKey,
        usernameController: _usernameController,
        selectedImage: _selectedImage,
        ref: ref,
        profilePhotoUrl: _profilePhotoUrl,
        isUpdating: _updating,
      );
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }
}
