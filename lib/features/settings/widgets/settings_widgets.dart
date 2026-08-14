import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/theme_controller.dart';

// =============================================================
// MAIN SETTINGS VIEW BODY
// =============================================================

class SettingsViewBody extends StatefulWidget {
  const SettingsViewBody({super.key});

  @override
  State<SettingsViewBody> createState() => _SettingsViewBodyState();
}

class _SettingsViewBodyState extends State<SettingsViewBody> {
  // User Profile State
  String _name = 'Sarah Jenkins';
  String _email = 'hr@hrm.com';
  final String _role = 'HR Manager';
  String _department = 'Human Resources';
  String _phone = '+1 (555) 234-5678';
  final String _joinDate = 'March 15, 2023';

  // Preferences
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _twoFactorAuth = false;

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ChangePasswordDialog(
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text('Password changed successfully!'),
                ],
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }

  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ResetPasswordDialog(
        email: _email,
        onConfirmed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.mail_outline_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Password reset instructions sent to $_email',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }

  void _showFullProfileDialog() {
    showDialog(
      context: context,
      builder: (ctx) => FullProfileDialog(
        name: _name,
        email: _email,
        role: _role,
        department: _department,
        phone: _phone,
        joinDate: _joinDate,
        onSave: (newName, newEmail, newPhone, newDept) {
          setState(() {
            _name = newName;
            _email = newEmail;
            _phone = newPhone;
            _department = newDept;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text('Profile updated successfully!'),
                ],
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Settings Header matching reference
            const SettingsHeaderWidget(),
            const SizedBox(height: 18),

            // 2. Account Section Card
            AccountSettingsCardWidget(
              email: _email,
              role: _role,
              onViewProfile: _showFullProfileDialog,
            ),
            const SizedBox(height: 18),

            // 3. Security Section Card
            SecuritySettingsCardWidget(
              onChangePassword: _showChangePasswordDialog,
              onResetPassword: _showResetPasswordDialog,
            ),
            const SizedBox(height: 18),

            // 4. Preferences & Theme Card
            PreferencesSettingsCardWidget(
              emailNotifications: _emailNotifications,
              pushNotifications: _pushNotifications,
              twoFactorAuth: _twoFactorAuth,
              onEmailNotifChanged: (val) => setState(() => _emailNotifications = val),
              onPushNotifChanged: (val) => setState(() => _pushNotifications = val),
              onTwoFactorChanged: (val) => setState(() => _twoFactorAuth = val),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// 1. HEADER CUSTOM WIDGET
// =============================================================

class SettingsHeaderWidget extends StatelessWidget {
  const SettingsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Blue-to-Purple gradient container matching reference
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF3B82F6), // Blue
                Color(0xFF8B5CF6), // Purple
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withAlpha(50),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.settings_outlined,
            color: Colors.white,
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Application preferences',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================
// 2. ACCOUNT SETTINGS CARD WIDGET
// =============================================================

class AccountSettingsCardWidget extends StatelessWidget {
  final String email;
  final String role;
  final VoidCallback onViewProfile;

  const AccountSettingsCardWidget({
    super.key,
    required this.email,
    required this.role,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: theme.dividerColor.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: User icon + "Account" + Subtitle
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9).withAlpha(20),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFF0284C7),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Connected to backend profile API',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Email Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Email',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Flexible(
                child: Text(
                  email,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Role Row with purple pill badge matching reference
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Role',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF), // Soft purple
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role,
                  style: const TextStyle(
                    color: Color(0xFF9333EA), // Purple text
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Action: "View Full Profile >" Button
          OutlinedButton(
            onPressed: onViewProfile,
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurface,
              side: BorderSide(color: theme.dividerColor.withAlpha(80)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Full Profile',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// 3. SECURITY SETTINGS CARD WIDGET
// =============================================================

class SecuritySettingsCardWidget extends StatelessWidget {
  final VoidCallback onChangePassword;
  final VoidCallback onResetPassword;

  const SecuritySettingsCardWidget({
    super.key,
    required this.onChangePassword,
    required this.onResetPassword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: theme.dividerColor.withAlpha(50),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Cyan Left Accent Curve/Bar matching reference image
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Cyan Lock Icon + "Security" + Subtitle
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF06B6D4).withAlpha(20),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          color: Color(0xFF0891B2),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Security',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Manage your password and security settings',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Advisory Description
                  Text(
                    'Keep your account secure by changing your password regularly and never sharing it with anyone.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons: "Change Password" (Gradient) & "Reset Password" (Outlined)
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      // Change Password Button with vibrant gradient
                      InkWell(
                        onTap: onChangePassword,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF0284C7), // Sky/Blue
                                Color(0xFF8B5CF6), // Purple
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0284C7).withAlpha(40),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Change Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      // Reset Password Outlined Button
                      OutlinedButton(
                        onPressed: onResetPassword,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurface,
                          side: BorderSide(color: theme.dividerColor.withAlpha(80)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        ),
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// 4. PREFERENCES & SYSTEM CARD WIDGET
// =============================================================

class PreferencesSettingsCardWidget extends StatelessWidget {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool twoFactorAuth;
  final ValueChanged<bool> onEmailNotifChanged;
  final ValueChanged<bool> onPushNotifChanged;
  final ValueChanged<bool> onTwoFactorChanged;

  const PreferencesSettingsCardWidget({
    super.key,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.twoFactorAuth,
    required this.onEmailNotifChanged,
    required this.onPushNotifChanged,
    required this.onTwoFactorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.find<ThemeController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: theme.dividerColor.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Preferences',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Theme, notifications and system configuration',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dark Mode Switch
          Obx(
            () => SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: themeController.isDarkMode,
              title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text(
                'Switch between light and dark visual themes',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
              ),
              activeTrackColor: AppColors.primary,
              onChanged: (_) async {
                await themeController.toggleTheme();
              },
            ),
          ),
          Divider(height: 20, color: theme.dividerColor.withAlpha(40)),

          // Email Notifications Switch
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: emailNotifications,
            title: const Text('Email Notifications', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: Text(
              'Receive monthly payroll, leave and meeting digests',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
            ),
            activeTrackColor: AppColors.primary,
            onChanged: onEmailNotifChanged,
          ),
          Divider(height: 20, color: theme.dividerColor.withAlpha(40)),

          // Push Notifications Switch
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: pushNotifications,
            title: const Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: Text(
              'Instant alerts for expense approvals and leave requests',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
            ),
            activeTrackColor: AppColors.primary,
            onChanged: onPushNotifChanged,
          ),
          Divider(height: 20, color: theme.dividerColor.withAlpha(40)),

          // Two Factor Authentication
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: twoFactorAuth,
            title: const Text('Two-Factor Authentication (2FA)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: Text(
              'Require one-time passcode for HR sensitive actions',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
            ),
            activeTrackColor: AppColors.primary,
            onChanged: onTwoFactorChanged,
          ),
          Divider(height: 20, color: theme.dividerColor.withAlpha(40)),

          // Version details
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Application Build',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'v1.2.0 (Production)',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// 5. CHANGE PASSWORD MODAL DIALOG
// =============================================================

class ChangePasswordDialog extends StatefulWidget {
  final VoidCallback onSuccess;

  const ChangePasswordDialog({super.key, required this.onSuccess});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final current = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (current.isEmpty) {
      setState(() => _errorMessage = 'Please enter your current password.');
      return;
    }
    if (newPass.length < 6) {
      setState(() => _errorMessage = 'New password must be at least 6 characters.');
      return;
    }
    if (newPass != confirmPass) {
      setState(() => _errorMessage = 'New passwords do not match.');
      return;
    }

    widget.onSuccess();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: theme.cardColor,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withAlpha(24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.lock_reset_rounded, color: Color(0xFF0284C7), size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Change Password',
              style: AppTextStyles.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.error.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.error.withAlpha(40)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: AppColors.error, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                Text('Current Password', style: AppTextStyles.labelMedium),
                const SizedBox(height: 6),
                TextField(
                  controller: _currentPasswordController,
                  obscureText: _obscureCurrent,
                  decoration: _passwordInputDecoration(
                    theme,
                    'Enter current password',
                    _obscureCurrent,
                    () => setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                ),
                const SizedBox(height: 14),

                Text('New Password', style: AppTextStyles.labelMedium),
                const SizedBox(height: 6),
                TextField(
                  controller: _newPasswordController,
                  obscureText: _obscureNew,
                  decoration: _passwordInputDecoration(
                    theme,
                    'Min 6 characters',
                    _obscureNew,
                    () => setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
                const SizedBox(height: 14),

                Text('Confirm New Password', style: AppTextStyles.labelMedium),
                const SizedBox(height: 6),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  decoration: _passwordInputDecoration(
                    theme,
                    'Re-enter new password',
                    _obscureConfirm,
                    () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        ),
        FilledButton(
          onPressed: _handleSubmit,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Update Password'),
        ),
      ],
    );
  }

  InputDecoration _passwordInputDecoration(
    ThemeData theme,
    String hint,
    bool isObscured,
    VoidCallback onToggle,
  ) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: theme.colorScheme.surface,
      suffixIcon: IconButton(
        icon: Icon(
          isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        onPressed: onToggle,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}

// =============================================================
// 6. RESET PASSWORD MODAL DIALOG
// =============================================================

class ResetPasswordDialog extends StatelessWidget {
  final String email;
  final VoidCallback onConfirmed;

  const ResetPasswordDialog({
    super.key,
    required this.email,
    required this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: theme.cardColor,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warning.withAlpha(24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.mail_lock_rounded, color: AppColors.warning, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Reset Password',
              style: AppTextStyles.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to request a password reset?',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'A secure link with reset instructions will be sent to:',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Text(
                  email,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        ),
        FilledButton(
          onPressed: () {
            onConfirmed();
            Navigator.of(context).pop();
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Send Reset Link'),
        ),
      ],
    );
  }
}

// =============================================================
// 7. FULL PROFILE MODAL DIALOG
// =============================================================

class FullProfileDialog extends StatefulWidget {
  final String name;
  final String email;
  final String role;
  final String department;
  final String phone;
  final String joinDate;
  final void Function(String name, String email, String phone, String department) onSave;

  const FullProfileDialog({
    super.key,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.phone,
    required this.joinDate,
    required this.onSave,
  });

  @override
  State<FullProfileDialog> createState() => _FullProfileDialogState();
}

class _FullProfileDialogState extends State<FullProfileDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _departmentController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _departmentController = TextEditingController(text: widget.department);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: theme.cardColor,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF9333EA).withAlpha(24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.badge_rounded, color: Color(0xFF9333EA), size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'User Profile Details',
              style: AppTextStyles.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar and Role Badge Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primary.withAlpha(30),
                      child: const Icon(Icons.person_rounded, size: 40, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.role,
                        style: const TextStyle(
                          color: Color(0xFF9333EA),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Member since ${widget.joinDate}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              Text('Full Name', style: AppTextStyles.labelMedium),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: _profileInputDecoration(theme),
              ),
              const SizedBox(height: 12),

              Text('Email Address', style: AppTextStyles.labelMedium),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                decoration: _profileInputDecoration(theme),
              ),
              const SizedBox(height: 12),

              Text('Department', style: AppTextStyles.labelMedium),
              const SizedBox(height: 6),
              TextField(
                controller: _departmentController,
                decoration: _profileInputDecoration(theme),
              ),
              const SizedBox(height: 12),

              Text('Phone Number', style: AppTextStyles.labelMedium),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                decoration: _profileInputDecoration(theme),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        ),
        FilledButton(
          onPressed: () {
            widget.onSave(
              _nameController.text.trim(),
              _emailController.text.trim(),
              _phoneController.text.trim(),
              _departmentController.text.trim(),
            );
            Navigator.of(context).pop();
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Save Profile'),
        ),
      ],
    );
  }

  InputDecoration _profileInputDecoration(ThemeData theme) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
