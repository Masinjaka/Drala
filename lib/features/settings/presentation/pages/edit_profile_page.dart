import 'dart:io';

import 'package:budgets/core/functions/pick_image_with_permissions.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/settings/data/repositories/supabase_account_data_repository.dart';
import 'package:budgets/features/settings/data/repositories/unavailable_account_data_repository.dart';
import 'package:budgets/features/settings/data/services/account_data_service.dart';
import 'package:budgets/features/settings/domain/repositories/account_data_repository.dart';
import 'package:budgets/features/settings/presentation/modules/edit_profile_module.dart';
import 'package:budgets/features/settings/presentation/view_models/danger_zone_view_model.dart';
import 'package:budgets/features/settings/presentation/widgets/danger_zone.dart';
import 'package:budgets/features/settings/presentation/widgets/editable_profile_avatar.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_shell.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_editor_sheet.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_transaction_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_sheet_route.dart';
import 'package:budgets/features/user/domain/provider/user_providers.dart';
import 'package:budgets/features/user/presentation/controllers/username_controller.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({this.onDataDeleted, this.asSheet = false, super.key});

  final VoidCallback? onDataDeleted;
  final bool asSheet;

  static Future<void> show(BuildContext context,
          {VoidCallback? onDataDeleted}) =>
      showTransactionFormSheet<void>(context,
          builder: (_) => EditProfilePage(
                onDataDeleted: onDataDeleted,
                asSheet: true,
              ));

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _module = EditProfileModule();
  late final DangerZoneViewModel _dangerViewModel;
  File? _selectedImage;
  String? _profilePhotoUrl;
  bool _loadingPhoto = true;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    _dangerViewModel = DangerZoneViewModel(_repository());
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
    _dangerViewModel.dispose();
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
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
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
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: context.l10n.save,
            height: 40,
            borderRadius: BorderRadius.circular(6),
            isLoading: _updating,
            onPressed: _updating ? null : _save,
          ),
          const SizedBox(height: 42),
          DangerZone(
            viewModel: _dangerViewModel,
            accountEmail: _accountEmail(),
            onDataDeleted: _dataDeleted,
            onAccountDeleted: () => context.go('/getting-started'),
          ),
        ],
      ),
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: widget.asSheet
          ? SettingsEditorSheet(title: context.l10n.editProfile, child: form)
          : SettingsPageShell(title: context.l10n.editProfile, child: form),
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

  void _dataDeleted() {
    widget.onDataDeleted?.call();
    if (!mounted) return;
    if (widget.onDataDeleted == null) {
      context.go('/home');
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  String _accountEmail() =>
      Supabase.instance.client.auth.currentUser?.email ?? '';

  AccountDataRepository _repository() {
    try {
      return SupabaseAccountDataRepository(
        AccountDataService(Supabase.instance.client),
      );
    } catch (_) {
      return const UnavailableAccountDataRepository();
    }
  }
}
