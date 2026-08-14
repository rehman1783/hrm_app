import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// =============================================================
// DATA MODEL & ENUMS
// =============================================================

enum PayrollStatus { paid, pending }

class PayrollRecord {
  final String id;
  final String employeeName;
  final String employeeRole;
  final String department;
  final String monthYear;
  final double baseSalary;
  final double bonus;
  final double deductions;
  final double netSalary;
  PayrollStatus status;
  final String paymentDate;

  PayrollRecord({
    required this.id,
    required this.employeeName,
    required this.employeeRole,
    required this.department,
    required this.monthYear,
    required this.baseSalary,
    required this.bonus,
    required this.deductions,
    required this.netSalary,
    required this.status,
    required this.paymentDate,
  });
}

// =============================================================
// MAIN BODY WIDGET (STATEFUL)
// =============================================================

class PayrollViewBody extends StatefulWidget {
  const PayrollViewBody({super.key});

  @override
  State<PayrollViewBody> createState() => _PayrollViewBodyState();
}

class _PayrollViewBodyState extends State<PayrollViewBody> {
  final double _usdToPkrRate = 278.01;
  bool _isPkr = true;
  String _selectedStatusFilter = 'All Statuses';

  final TextEditingController _monthController = TextEditingController(text: '8');
  final TextEditingController _yearController = TextEditingController(text: '2026');

  late List<PayrollRecord> _payrollList;

  @override
  void initState() {
    super.initState();
    _payrollList = [
      PayrollRecord(
        id: 'PAY-001',
        employeeName: 'User (HR Manager)',
        employeeRole: 'HR Manager',
        department: 'Human Resources',
        monthYear: '08/2026',
        baseSalary: 180000,
        bonus: 15000,
        deductions: 8000,
        netSalary: 187000,
        status: PayrollStatus.paid,
        paymentDate: 'Aug 05, 2026',
      ),
      PayrollRecord(
        id: 'PAY-002',
        employeeName: 'Sarah Jenkins',
        employeeRole: 'Lead Mobile Developer',
        department: 'Engineering',
        monthYear: '08/2026',
        baseSalary: 220000,
        bonus: 20000,
        deductions: 10000,
        netSalary: 230000,
        status: PayrollStatus.paid,
        paymentDate: 'Aug 05, 2026',
      ),
      PayrollRecord(
        id: 'PAY-003',
        employeeName: 'Ali Khan',
        employeeRole: 'UI/UX Designer',
        department: 'Design',
        monthYear: '08/2026',
        baseSalary: 140000,
        bonus: 8000,
        deductions: 5000,
        netSalary: 143000,
        status: PayrollStatus.pending,
        paymentDate: 'Pending',
      ),
    ];
  }

  @override
  void dispose() {
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  // --- STATS COMPUTATION ---
  int get _totalRecords => _payrollList.length;
  int get _paidCount => _payrollList.where((p) => p.status == PayrollStatus.paid).length;
  int get _pendingCount => _payrollList.where((p) => p.status == PayrollStatus.pending).length;
  double get _totalPaidAmount => _payrollList
      .where((p) => p.status == PayrollStatus.paid)
      .fold(0.0, (sum, item) => sum + item.netSalary);

  String _formatAmount(double pkrAmount) {
    if (_isPkr) {
      return 'Rs. ${pkrAmount.toStringAsFixed(0)}';
    } else {
      final usd = pkrAmount / _usdToPkrRate;
      return '\$${usd.toStringAsFixed(2)}';
    }
  }

  List<PayrollRecord> get _filteredRecords {
    return _payrollList.where((rec) {
      if (_selectedStatusFilter == 'Paid' && rec.status != PayrollStatus.paid) return false;
      if (_selectedStatusFilter == 'Pending' && rec.status != PayrollStatus.pending) return false;
      return true;
    }).toList();
  }

  // --- ACTIONS ---
  void _openPaySalaryDialog() {
    final nameController = TextEditingController(text: 'Zubair Ahmed');
    final roleController = TextEditingController(text: 'QA Engineer');
    final deptController = TextEditingController(text: 'Engineering');
    final salaryController = TextEditingController(text: '125000');
    final bonusController = TextEditingController(text: '5000');
    final deductionController = TextEditingController(text: '3000');

    showDialog(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.success.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.payments_rounded, color: AppColors.success, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Pay Employee Salary',
                          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    _buildTextField(label: 'EMPLOYEE NAME', controller: nameController, theme: theme),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(label: 'ROLE', controller: roleController, theme: theme)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildTextField(label: 'DEPARTMENT', controller: deptController, theme: theme)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(label: 'BASE SALARY (PKR)', controller: salaryController, keyboardType: TextInputType.number, theme: theme),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(label: 'BONUS (PKR)', controller: bonusController, keyboardType: TextInputType.number, theme: theme)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildTextField(label: 'DEDUCTIONS (PKR)', controller: deductionController, keyboardType: TextInputType.number, theme: theme)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: () {
                            final base = double.tryParse(salaryController.text.trim()) ?? 0;
                            final bonus = double.tryParse(bonusController.text.trim()) ?? 0;
                            final ded = double.tryParse(deductionController.text.trim()) ?? 0;
                            final net = (base + bonus) - ded;

                            setState(() {
                              _payrollList.insert(
                                0,
                                PayrollRecord(
                                  id: 'PAY-00${_payrollList.length + 1}',
                                  employeeName: nameController.text.trim().isEmpty ? 'Employee' : nameController.text.trim(),
                                  employeeRole: roleController.text.trim().isEmpty ? 'Staff' : roleController.text.trim(),
                                  department: deptController.text.trim().isEmpty ? 'General' : deptController.text.trim(),
                                  monthYear: '${_monthController.text}/${_yearController.text}',
                                  baseSalary: base,
                                  bonus: bonus,
                                  deductions: ded,
                                  netSalary: net,
                                  status: PayrollStatus.paid,
                                  paymentDate: 'Today',
                                ),
                              );
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Salary of Rs. ${net.toStringAsFixed(0)} processed successfully!'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.check_rounded, size: 16),
                          label: const Text('Confirm Payment'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.success,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _generatePayrollForPeriod() {
    final month = _monthController.text.trim();
    final year = _yearController.text.trim();

    setState(() {
      // Simulate bulk payroll generation
      _payrollList.add(
        PayrollRecord(
          id: 'PAY-00${_payrollList.length + 1}',
          employeeName: 'Hamza Tariq',
          employeeRole: 'Full Stack Engineer',
          department: 'Engineering',
          monthYear: '$month/$year',
          baseSalary: 160000,
          bonus: 10000,
          deductions: 5000,
          netSalary: 165000,
          status: PayrollStatus.paid,
          paymentDate: 'Generated ($month/$year)',
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payroll generated for period $month/$year!'),
        backgroundColor: themePrimaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color get themePrimaryColor => Theme.of(context).colorScheme.primary;

  void _showPayslipDetails(PayrollRecord item) {
    showDialog(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PAYSLIP BREAKDOWN', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(item.employeeName, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 18)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.status == PayrollStatus.paid ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.status == PayrollStatus.paid ? 'PAID' : 'PENDING',
                          style: TextStyle(
                            color: item.status == PayrollStatus.paid ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 14),

                  _buildDetailRow('Reference ID', item.id, theme),
                  _buildDetailRow('Period', item.monthYear, theme),
                  _buildDetailRow('Department', item.department, theme),
                  _buildDetailRow('Designation', item.employeeRole, theme),
                  _buildDetailRow('Base Salary', _formatAmount(item.baseSalary), theme),
                  _buildDetailRow('Bonus / Allowances', '+ ${_formatAmount(item.bonus)}', theme, valueColor: AppColors.success),
                  _buildDetailRow('Deductions / Tax', '- ${_formatAmount(item.deductions)}', theme, valueColor: Colors.red),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  _buildDetailRow('Net Salary Paid', _formatAmount(item.netSalary), theme, isBold: true),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (item.status == PayrollStatus.pending)
                        FilledButton.icon(
                          onPressed: () {
                            setState(() => item.status = PayrollStatus.paid);
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Marked as Paid!'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                          label: const Text('Mark as Paid'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.success,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required ThemeData theme,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.dividerColor.withAlpha(80)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? theme.colorScheme.onSurface,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              fontSize: isBold ? 15 : 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header
            _buildHeader(theme),
            const SizedBox(height: 12),

            // 2. Stats
            _buildStats(theme),
            const SizedBox(height: 12),

            // 3. Live Exchange Rate
            _buildExchangeRateBar(theme),
            const SizedBox(height: 14),

            // 4. Generate Payroll
            _buildGenerateSection(theme),
            const SizedBox(height: 14),

            // 5. Records & List
            _buildRecordsSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payroll', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 2),
              Text(
                '8/2026',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: _openPaySalaryDialog,
          icon: const Icon(Icons.attach_money_rounded, size: 18),
          label: const Text('Pay Salary'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.success,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;
        final statList = [
          (
            'TOTAL RECORDS',
            '$_totalRecords',
            'Payroll entries',
            Icons.receipt_rounded,
            const Color(0xFF60A5FA),
          ),
          (
            'PAID',
            '$_paidCount',
            'Completed payments',
            Icons.check_circle_rounded,
            AppColors.success,
          ),
          (
            'PENDING',
            '$_pendingCount',
            'Awaiting approval',
            Icons.schedule_rounded,
            const Color(0xFFF59E0B),
          ),
          (
            'TOTAL PAID',
            _formatAmount(_totalPaidAmount),
            'Cumulative total',
            Icons.account_balance_wallet_rounded,
            const Color(0xFF8B5CF6),
          ),
        ];

        if (isMobile) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatCard(statList[0], theme)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatCard(statList[1], theme)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildStatCard(statList[2], theme)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatCard(statList[3], theme)),
                ],
              ),
            ],
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: statList
                .asMap()
                .entries
                .map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(right: entry.key < 3 ? 10 : 0),
                    child: SizedBox(
                      width: 180,
                      child: _buildStatCard(entry.value, theme),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildStatCard((String, String, String, IconData, Color) stat, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  stat.$1,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: stat.$5.withAlpha(24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(stat.$4, color: stat.$5, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            stat.$2,
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stat.$3,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeRateBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          Icon(Icons.trending_up_rounded, color: theme.colorScheme.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Exchange Rate:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '1 USD = $_usdToPkrRate PKR',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Live Sync',
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month_rounded, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 10),
              const Text('Generate Payroll', style: AppTextStyles.titleMedium),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MONTH', style: AppTextStyles.labelMedium.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _monthController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('YEAR', style: AppTextStyles.labelMedium.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _yearController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: FilledButton.icon(
                  onPressed: _generatePayrollForPeriod,
                  icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                  label: const Text('Generate'),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsSection(ThemeData theme) {
    final list = _filteredRecords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.receipt_long_rounded, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            const Text('Payroll Records', style: AppTextStyles.titleMedium),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${list.length} entries',
                style: AppTextStyles.labelMedium.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Filter Bar & Currency Switches
        Row(
          children: [
            // Status Dropdown
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor.withAlpha(80)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedStatusFilter,
                    isExpanded: true,
                    icon: Icon(Icons.expand_more_rounded, size: 18, color: theme.colorScheme.onSurfaceVariant),
                    items: const [
                      DropdownMenuItem(value: 'All Statuses', child: Text('All Statuses', style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(value: 'Paid', child: Text('Paid Only', style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(value: 'Pending', child: Text('Pending Only', style: TextStyle(fontSize: 13))),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedStatusFilter = val);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // PKR Toggle
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _isPkr = true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: _isPkr ? AppColors.success.withAlpha(30) : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isPkr ? AppColors.success : theme.dividerColor.withAlpha(80),
                  ),
                ),
                child: Text(
                  'PKR (Rs.)',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _isPkr ? AppColors.success : theme.colorScheme.onSurface,
                    fontWeight: _isPkr ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),

            // USD Toggle
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _isPkr = false),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: !_isPkr ? AppColors.primary.withAlpha(30) : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: !_isPkr ? AppColors.primary : theme.dividerColor.withAlpha(80),
                  ),
                ),
                child: Text(
                  'USD (\$)',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: !_isPkr ? AppColors.primary : theme.colorScheme.onSurface,
                    fontWeight: !_isPkr ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // List
        if (list.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha(12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.success.withAlpha(30)),
            ),
            child: Column(
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.success.withAlpha(150), size: 28),
                const SizedBox(height: 10),
                Text(
                  'No payroll records found for this filter',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success.withAlpha(180)),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = list[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withAlpha(10),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: theme.colorScheme.primary.withAlpha(25),
                          child: Text(
                            item.employeeName.isNotEmpty ? item.employeeName[0] : 'E',
                            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.employeeName, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text('${item.employeeRole} • ${item.department}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: item.status == PayrollStatus.paid ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.status == PayrollStatus.paid ? 'Paid' : 'Pending',
                            style: TextStyle(
                              color: item.status == PayrollStatus.paid ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NET PAYABLE', style: AppTextStyles.labelMedium.copyWith(color: theme.colorScheme.onSurfaceVariant, fontSize: 10)),
                            const SizedBox(height: 2),
                            Text(_formatAmount(item.netSalary), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          ],
                        ),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _showPayslipDetails(item),
                              icon: const Icon(Icons.receipt_rounded, size: 14),
                              label: const Text('Slip', style: TextStyle(fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            if (item.status == PayrollStatus.pending) ...[
                              const SizedBox(width: 8),
                              FilledButton(
                                onPressed: () {
                                  setState(() => item.status = PayrollStatus.paid);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Payment to ${item.employeeName} approved!'),
                                      backgroundColor: AppColors.success,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Pay Now', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
