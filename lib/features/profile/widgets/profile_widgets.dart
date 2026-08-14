import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// =============================================================
// USER PROFILE MODEL
// =============================================================

class UserProfileData {
  String name;
  String employeeType;
  bool isActive;
  String roleBadge;
  String email;
  String employeeId;
  String fatherName;
  String cnic;
  String phone;
  String department;
  String joiningDate;
  String location;
  String shift;

  // Professional details
  String designation;
  String workMode;
  String workType;
  String paymentType;
  String salary;
  String projectBudget;
  String gender;

  // Skills
  List<String> skills;
  String since;

  UserProfileData({
    this.name = 'User',
    this.employeeType = 'Employee',
    this.isActive = false,
    this.roleBadge = 'HR Manager',
    this.email = 'hr@hrm.com',
    this.employeeId = '-',
    this.fatherName = '-',
    this.cnic = '-',
    this.phone = '-',
    this.department = '-',
    this.joiningDate = '-',
    this.location = '—',
    this.shift = '-',
    this.designation = '-',
    this.workMode = '-',
    this.workType = '-',
    this.paymentType = '-',
    this.salary = '-',
    this.projectBudget = '-',
    this.gender = '-',
    List<String>? skills,
    this.since = '-',
  }) : skills = skills ?? [];
}

// =============================================================
// MAIN PROFILE VIEW BODY
// =============================================================

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  late UserProfileData _profile;

  @override
  void initState() {
    super.initState();
    _profile = UserProfileData();
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (ctx) => EditProfileDialog(
        initialData: _profile,
        onSave: (updated) {
          setState(() {
            _profile = updated;
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

  void _showAddSkillDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AddSkillDialog(
        initialSkills: _profile.skills,
        onSave: (newSkills) {
          setState(() {
            _profile.skills = newSkills;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text('Skills updated successfully!'),
                ],
              ),
              backgroundColor: const Color(0xFF00C853),
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
            // 1. Profile Top Header
            ProfileHeaderWidget(onEditPressed: _showEditProfileDialog),
            const SizedBox(height: 16),

            // 2. Responsive 2-Column or Stacking Layout
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 820;

                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Personal Overview Card
                      Expanded(
                        flex: 5,
                        child: PersonalOverviewCardWidget(profile: _profile),
                      ),
                      const SizedBox(width: 16),

                      // Right Column: Professional Details, Skills & Metrics
                      Expanded(
                        flex: 7,
                        child: Column(
                          children: [
                            ProfessionalDetailsCardWidget(profile: _profile),
                            const SizedBox(height: 16),
                            SkillsExpertiseCardWidget(
                              skills: _profile.skills,
                              onAddSkill: _showAddSkillDialog,
                            ),
                            const SizedBox(height: 16),
                            ProfileStatusMetricsRowWidget(profile: _profile),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                // Mobile / Tablet stacked view
                return Column(
                  children: [
                    PersonalOverviewCardWidget(profile: _profile),
                    const SizedBox(height: 16),
                    ProfessionalDetailsCardWidget(profile: _profile),
                    const SizedBox(height: 16),
                    SkillsExpertiseCardWidget(
                      skills: _profile.skills,
                      onAddSkill: _showAddSkillDialog,
                    ),
                    const SizedBox(height: 16),
                    ProfileStatusMetricsRowWidget(profile: _profile),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// 1. TOP HEADER WIDGET
// =============================================================

class ProfileHeaderWidget extends StatelessWidget {
  final VoidCallback onEditPressed;

  const ProfileHeaderWidget({super.key, required this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title & Icon section
        Expanded(
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withAlpha(45),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Profile',
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        letterSpacing: -0.4,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'View and manage your personal information',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // Compact & Stylish "Edit Profile" Button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onEditPressed,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0284C7), // Sky Blue
                    Color(0xFF8B5CF6), // Purple
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withAlpha(40),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 5),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================
// 2. LEFT CARD: PERSONAL OVERVIEW CARD WIDGET
// =============================================================

class PersonalOverviewCardWidget extends StatelessWidget {
  final UserProfileData profile;

  const PersonalOverviewCardWidget({super.key, required this.profile});

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
        border: Border.all(color: theme.dividerColor.withAlpha(50)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Profile Header Container (ambient soft cyan gradient with dual-ring avatar)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFE0F2FE).withAlpha(130),
                    const Color(0xFFF0FDF4).withAlpha(70),
                    theme.cardColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Dual-ring Avatar with vibrant gradient & glowing shadow
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF38BDF8).withAlpha(180),
                          const Color(0xFF818CF8).withAlpha(180),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0284C7).withAlpha(50),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Container(
                      width: 82,
                      height: 82,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF0284C7), // Blue
                            Color(0xFF6366F1), // Indigo
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Name & Role Subtitle
                  Text(
                    profile.name,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      letterSpacing: -0.4,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    profile.employeeType,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Badges Row: Status ("⊘ Inactive") + Role ("HR Manager")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Status Chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                        decoration: BoxDecoration(
                          color: profile.isActive
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: profile.isActive
                                ? const Color(0xFF86EFAC)
                                : const Color(0xFFFCA5A5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              profile.isActive
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.cancel_outlined,
                              size: 13,
                              color: profile.isActive
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFFDC2626),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              profile.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                color: profile.isActive
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFFDC2626),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Purple Role Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          profile.roleBadge,
                          style: const TextStyle(
                            color: Color(0xFF9333EA),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 9 Personal Detail Rows with colorful icons matching reference
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _ProfileDetailRow(
                    icon: Icons.email_outlined,
                    iconBgColor: const Color(0xFF0EA5E9).withAlpha(20),
                    iconColor: const Color(0xFF0284C7),
                    label: 'EMAIL',
                    value: profile.email,
                  ),
                  _divider(theme),
                  _ProfileDetailRow(
                    icon: Icons.badge_outlined,
                    iconBgColor: const Color(0xFF22C55E).withAlpha(20),
                    iconColor: const Color(0xFF16A34A),
                    label: 'EMPLOYEE ID',
                    value: profile.employeeId,
                  ),
                  _divider(theme),
                  _ProfileDetailRow(
                    icon: Icons.person_outline_rounded,
                    iconBgColor: const Color(0xFF8B5CF6).withAlpha(20),
                    iconColor: const Color(0xFF7C3AED),
                    label: 'FATHER NAME',
                    value: profile.fatherName,
                  ),
                  _divider(theme),
                  _ProfileDetailRow(
                    icon: Icons.credit_card_rounded,
                    iconBgColor: const Color(0xFFA855F7).withAlpha(20),
                    iconColor: const Color(0xFF9333EA),
                    label: 'CNIC / PASSPORT',
                    value: profile.cnic,
                  ),
                  _divider(theme),
                  _ProfileDetailRow(
                    icon: Icons.phone_android_rounded,
                    iconBgColor: const Color(0xFFF59E0B).withAlpha(20),
                    iconColor: const Color(0xFFD97706),
                    label: 'PHONE',
                    value: profile.phone,
                  ),
                  _divider(theme),
                  _ProfileDetailRow(
                    icon: Icons.apartment_rounded,
                    iconBgColor: const Color(0xFF6366F1).withAlpha(20),
                    iconColor: const Color(0xFF4F46E5),
                    label: 'DEPARTMENT',
                    value: profile.department,
                  ),
                  _divider(theme),
                  _ProfileDetailRow(
                    icon: Icons.calendar_today_rounded,
                    iconBgColor: const Color(0xFF38BDF8).withAlpha(20),
                    iconColor: const Color(0xFF0284C7),
                    label: 'JOINING DATE',
                    value: profile.joiningDate,
                  ),
                  _divider(theme),
                  _ProfileDetailRow(
                    icon: Icons.location_on_outlined,
                    iconBgColor: const Color(0xFFEF4444).withAlpha(20),
                    iconColor: const Color(0xFFDC2626),
                    label: 'LOCATION',
                    value: profile.location,
                  ),
                  _divider(theme),
                  _ProfileDetailRow(
                    icon: Icons.access_time_rounded,
                    iconBgColor: const Color(0xFFF97316).withAlpha(20),
                    iconColor: const Color(0xFFEA580C),
                    label: 'SHIFT',
                    value: profile.shift,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(ThemeData theme) {
    return Divider(height: 14, thickness: 0.8, color: theme.dividerColor.withAlpha(40));
  }
}

class _ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final String value;

  const _ProfileDetailRow({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
// 3. RIGHT CARD 1: PROFESSIONAL DETAILS CARD WIDGET
// =============================================================

class ProfessionalDetailsCardWidget extends StatelessWidget {
  final UserProfileData profile;

  const ProfessionalDetailsCardWidget({super.key, required this.profile});

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
        border: Border.all(color: theme.dividerColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Cyan Suitcase Icon + Green "Professional Details"
          Row(
            children: [
              const Icon(
                Icons.work_outline_rounded,
                color: Color(0xFF00C853), // Green
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Professional Details',
                style: AppTextStyles.titleMedium.copyWith(
                  color: const Color(0xFF00C853), // Bright vibrant green
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 8-Field Grid Layout (Designation, Department, Work Mode, Work Type, Payment Type, Salary, Project Budget, Gender)
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 450;
              final crossAxisCount = isCompact ? 1 : 2;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: isCompact ? 3.5 : 2.5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 16,
                children: [
                  _GridDetailItem(label: 'DESIGNATION', value: profile.designation),
                  _GridDetailItem(label: 'DEPARTMENT', value: profile.department),
                  _GridDetailItem(label: 'WORK MODE', value: profile.workMode),
                  _GridDetailItem(label: 'WORK TYPE', value: profile.workType),
                  _GridDetailItem(label: 'PAYMENT TYPE', value: profile.paymentType),
                  _GridDetailItem(label: 'SALARY', value: profile.salary),
                  _GridDetailItem(label: 'PROJECT BUDGET', value: profile.projectBudget),
                  _GridDetailItem(label: 'GENDER', value: profile.gender),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GridDetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _GridDetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// =============================================================
// 4. RIGHT CARD 2: SKILLS & EXPERTISE CARD WIDGET
// =============================================================

class SkillsExpertiseCardWidget extends StatelessWidget {
  final List<String> skills;
  final VoidCallback onAddSkill;

  const SkillsExpertiseCardWidget({
    super.key,
    required this.skills,
    required this.onAddSkill,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
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
        border: Border.all(color: theme.dividerColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.military_tech_outlined,
                    color: Color(0xFF00C853),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Skills & Expertise',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: const Color(0xFF00C853),
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onAddSkill,
                icon: const Icon(Icons.add_rounded, size: 20),
                tooltip: 'Add Skill',
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853).withAlpha(20),
                  foregroundColor: const Color(0xFF00C853),
                  padding: const EdgeInsets.all(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (skills.isEmpty)
            Text(
              'No skills listed',
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills
                  .map(
                    (skill) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C853).withAlpha(16),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF00C853).withAlpha(40),
                        ),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

// =============================================================
// 5. RIGHT CARD 3: STATUS & SINCE METRICS ROW
// =============================================================

class ProfileStatusMetricsRowWidget extends StatelessWidget {
  final UserProfileData profile;

  const ProfileStatusMetricsRowWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 400;

        final statusCard = Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4).withAlpha(100),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    profile.isActive
                        ? Icons.check_circle_outline_rounded
                        : Icons.cancel_outlined,
                    color: profile.isActive
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFDC2626),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'STATUS',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                profile.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: profile.isActive
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFDC2626),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );

        final sinceCard = Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB).withAlpha(100),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: Color(0xFFD97706),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'SINCE',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                profile.since,
                style: const TextStyle(
                  color: Color(0xFFD97706),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );

        if (isCompact) {
          return Column(
            children: [
              statusCard,
              const SizedBox(height: 12),
              sinceCard,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: statusCard),
            const SizedBox(width: 14),
            Expanded(child: sinceCard),
          ],
        );
      },
    );
  }
}

// =============================================================
// 6. EDIT PROFILE MODAL DIALOG
// =============================================================

class EditProfileDialog extends StatefulWidget {
  final UserProfileData initialData;
  final ValueChanged<UserProfileData> onSave;

  const EditProfileDialog({
    super.key,
    required this.initialData,
    required this.onSave,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _fatherNameCtrl;
  late final TextEditingController _cnicCtrl;
  late final TextEditingController _empIdCtrl;
  late final TextEditingController _deptCtrl;
  late final TextEditingController _joinDateCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _shiftCtrl;
  late final TextEditingController _designationCtrl;
  late final TextEditingController _workModeCtrl;
  late final TextEditingController _workTypeCtrl;
  late final TextEditingController _paymentTypeCtrl;
  late final TextEditingController _salaryCtrl;
  late final TextEditingController _projectBudgetCtrl;
  late final TextEditingController _genderCtrl;
  late final TextEditingController _skillInputCtrl;

  late bool _isActive;
  late List<String> _skills;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _nameCtrl = TextEditingController(text: d.name);
    _emailCtrl = TextEditingController(text: d.email);
    _phoneCtrl = TextEditingController(text: d.phone);
    _fatherNameCtrl = TextEditingController(text: d.fatherName);
    _cnicCtrl = TextEditingController(text: d.cnic);
    _empIdCtrl = TextEditingController(text: d.employeeId);
    _deptCtrl = TextEditingController(text: d.department);
    _joinDateCtrl = TextEditingController(text: d.joiningDate);
    _locationCtrl = TextEditingController(text: d.location);
    _shiftCtrl = TextEditingController(text: d.shift);
    _designationCtrl = TextEditingController(text: d.designation);
    _workModeCtrl = TextEditingController(text: d.workMode);
    _workTypeCtrl = TextEditingController(text: d.workType);
    _paymentTypeCtrl = TextEditingController(text: d.paymentType);
    _salaryCtrl = TextEditingController(text: d.salary);
    _projectBudgetCtrl = TextEditingController(text: d.projectBudget);
    _genderCtrl = TextEditingController(text: d.gender);
    _skillInputCtrl = TextEditingController();
    _isActive = d.isActive;
    _skills = List.from(d.skills);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _fatherNameCtrl.dispose();
    _cnicCtrl.dispose();
    _empIdCtrl.dispose();
    _deptCtrl.dispose();
    _joinDateCtrl.dispose();
    _locationCtrl.dispose();
    _shiftCtrl.dispose();
    _designationCtrl.dispose();
    _workModeCtrl.dispose();
    _workTypeCtrl.dispose();
    _paymentTypeCtrl.dispose();
    _salaryCtrl.dispose();
    _projectBudgetCtrl.dispose();
    _genderCtrl.dispose();
    _skillInputCtrl.dispose();
    super.dispose();
  }

  void _addSkill() {
    final skill = _skillInputCtrl.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillInputCtrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
            child: const Icon(Icons.edit_rounded, color: Color(0xFF0284C7), size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Edit Profile Information',
              style: AppTextStyles.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fully Responsive Active Status toggle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.dividerColor.withAlpha(80)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 320;

                    final leftSide = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Account Status',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _isActive ? 'Active profile' : 'Inactive profile',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    );

                    final rightSide = Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _isActive
                                ? const Color(0xFFDCFCE7)
                                : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isActive
                                  ? const Color(0xFF86EFAC)
                                  : const Color(0xFFFCA5A5),
                            ),
                          ),
                          child: Text(
                            _isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: _isActive
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFFDC2626),
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Switch.adaptive(
                          value: _isActive,
                          activeTrackColor: AppColors.success,
                          onChanged: (val) => setState(() => _isActive = val),
                        ),
                      ],
                    );

                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          leftSide,
                          const SizedBox(height: 8),
                          rightSide,
                        ],
                      );
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: leftSide),
                        const SizedBox(width: 8),
                        rightSide,
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              Text('Personal Details', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              _dialogField(theme, 'Full Name', _nameCtrl),
              _dialogField(theme, 'Email', _emailCtrl),
              _dialogField(theme, 'Employee ID', _empIdCtrl),
              _dialogField(theme, 'Father Name', _fatherNameCtrl),
              _dialogField(theme, 'CNIC / Passport', _cnicCtrl),
              _dialogField(theme, 'Phone', _phoneCtrl),
              _dialogField(theme, 'Department', _deptCtrl),
              _dialogField(theme, 'Joining Date', _joinDateCtrl),
              _dialogField(theme, 'Location', _locationCtrl),
              _dialogField(theme, 'Shift', _shiftCtrl),

              const SizedBox(height: 14),
              Text('Professional Details', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              _dialogField(theme, 'Designation', _designationCtrl),
              _dialogField(theme, 'Work Mode', _workModeCtrl),
              _dialogField(theme, 'Work Type', _workTypeCtrl),
              _dialogField(theme, 'Payment Type', _paymentTypeCtrl),
              _dialogField(theme, 'Salary', _salaryCtrl),
              _dialogField(theme, 'Project Budget', _projectBudgetCtrl),
              _dialogField(theme, 'Gender', _genderCtrl),

              const SizedBox(height: 14),
              Text('Skills & Expertise', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _skillInputCtrl,
                      decoration: InputDecoration(
                        hintText: 'Add skill (e.g. Flutter, HR)',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.dividerColor),
                        ),
                      ),
                      onSubmitted: (_) => _addSkill(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _addSkill,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
              if (_skills.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _skills
                      .map(
                        (s) => Chip(
                          label: Text(s, style: const TextStyle(fontSize: 12)),
                          deleteIcon: const Icon(Icons.close_rounded, size: 14),
                          onDeleted: () => setState(() => _skills.remove(s)),
                          backgroundColor: const Color(0xFF00C853).withAlpha(20),
                          side: BorderSide(color: const Color(0xFF00C853).withAlpha(40)),
                        ),
                      )
                      .toList(),
                ),
              ],
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
            final updated = UserProfileData(
              name: _nameCtrl.text.trim().isEmpty ? 'User' : _nameCtrl.text.trim(),
              employeeType: widget.initialData.employeeType,
              isActive: _isActive,
              roleBadge: widget.initialData.roleBadge,
              email: _emailCtrl.text.trim(),
              employeeId: _empIdCtrl.text.trim().isEmpty ? '-' : _empIdCtrl.text.trim(),
              fatherName: _fatherNameCtrl.text.trim().isEmpty ? '-' : _fatherNameCtrl.text.trim(),
              cnic: _cnicCtrl.text.trim().isEmpty ? '-' : _cnicCtrl.text.trim(),
              phone: _phoneCtrl.text.trim().isEmpty ? '-' : _phoneCtrl.text.trim(),
              department: _deptCtrl.text.trim().isEmpty ? '-' : _deptCtrl.text.trim(),
              joiningDate: _joinDateCtrl.text.trim().isEmpty ? '-' : _joinDateCtrl.text.trim(),
              location: _locationCtrl.text.trim().isEmpty ? '—' : _locationCtrl.text.trim(),
              shift: _shiftCtrl.text.trim().isEmpty ? '-' : _shiftCtrl.text.trim(),
              designation: _designationCtrl.text.trim().isEmpty ? '-' : _designationCtrl.text.trim(),
              workMode: _workModeCtrl.text.trim().isEmpty ? '-' : _workModeCtrl.text.trim(),
              workType: _workTypeCtrl.text.trim().isEmpty ? '-' : _workTypeCtrl.text.trim(),
              paymentType: _paymentTypeCtrl.text.trim().isEmpty ? '-' : _paymentTypeCtrl.text.trim(),
              salary: _salaryCtrl.text.trim().isEmpty ? '-' : _salaryCtrl.text.trim(),
              projectBudget: _projectBudgetCtrl.text.trim().isEmpty ? '-' : _projectBudgetCtrl.text.trim(),
              gender: _genderCtrl.text.trim().isEmpty ? '-' : _genderCtrl.text.trim(),
              skills: _skills,
              since: widget.initialData.since,
            );
            widget.onSave(updated);
            Navigator.of(context).pop();
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  Widget _dialogField(ThemeData theme, String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
        ),
      ),
    );
  }
}

// =============================================================
// 7. DEDICATED ADD SKILL MODAL DIALOG
// =============================================================

class AddSkillDialog extends StatefulWidget {
  final List<String> initialSkills;
  final ValueChanged<List<String>> onSave;

  const AddSkillDialog({
    super.key,
    required this.initialSkills,
    required this.onSave,
  });

  @override
  State<AddSkillDialog> createState() => _AddSkillDialogState();
}

class _AddSkillDialogState extends State<AddSkillDialog> {
  late final TextEditingController _skillCtrl;
  late final List<String> _skills;

  final List<String> _suggestedSkills = const [
    'Human Resources',
    'Recruitment',
    'Payroll Management',
    'Employee Relations',
    'Talent Acquisition',
    'Conflict Resolution',
    'Performance Review',
    'Leadership',
  ];

  @override
  void initState() {
    super.initState();
    _skillCtrl = TextEditingController();
    _skills = List.from(widget.initialSkills);
  }

  @override
  void dispose() {
    _skillCtrl.dispose();
    super.dispose();
  }

  void _addSkill([String? custom]) {
    final skill = (custom ?? _skillCtrl.text).trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        if (custom == null) {
          _skillCtrl.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: theme.cardColor,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF00C853).withAlpha(24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.military_tech_outlined,
              color: Color(0xFF00C853),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Add Skills & Expertise',
              style: AppTextStyles.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter a new skill or choose from suggestions below:',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 14),

              // Input field + Add button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _skillCtrl,
                      decoration: InputDecoration(
                        hintText: 'e.g. Employee Relations',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
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
                          borderSide: const BorderSide(color: Color(0xFF00C853), width: 1.5),
                        ),
                      ),
                      onSubmitted: (_) => _addSkill(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => _addSkill(),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Current Skills list
              Text(
                'Current Skills (${_skills.length})',
                style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (_skills.isEmpty)
                Text(
                  'No skills added yet.',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                )
              else
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _skills
                      .map(
                        (skill) => Chip(
                          label: Text(
                            skill,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          deleteIcon: const Icon(Icons.close_rounded, size: 14),
                          onDeleted: () => setState(() => _skills.remove(skill)),
                          backgroundColor: const Color(0xFF00C853).withAlpha(20),
                          side: BorderSide(color: const Color(0xFF00C853).withAlpha(40)),
                        ),
                      )
                      .toList(),
                ),

              const SizedBox(height: 18),
              // Suggested skills
              Text(
                'Suggestions',
                style: AppTextStyles.labelMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _suggestedSkills
                    .where((s) => !_skills.contains(s))
                    .map(
                      (suggestion) => ActionChip(
                        avatar: const Icon(Icons.add, size: 14, color: Color(0xFF00C853)),
                        label: Text(suggestion, style: const TextStyle(fontSize: 12)),
                        onPressed: () => _addSkill(suggestion),
                        backgroundColor: theme.colorScheme.surface,
                        side: BorderSide(color: theme.dividerColor.withAlpha(80)),
                      ),
                    )
                    .toList(),
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
            widget.onSave(_skills);
            Navigator.of(context).pop();
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF00C853),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Save Skills'),
        ),
      ],
    );
  }
}

