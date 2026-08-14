import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

enum FinanceTab { budgets, expenseClaims, invoices }

enum ClaimStatus { pending, approved, rejected }

enum InvoiceStatus { unpaid, paid, overdue }

class ExpenseClaimItem {
  final String id;
  final String employeeName;
  final String employeeEmail;
  final String category;
  final String date;
  final double amount;
  ClaimStatus status;
  final String? note;

  ExpenseClaimItem({
    required this.id,
    required this.employeeName,
    required this.employeeEmail,
    required this.category,
    required this.date,
    required this.amount,
    required this.status,
    this.note,
  });
}

class DepartmentBudgetItem {
  final String id;
  final String department;
  final double totalBudget;
  double spentAmount;
  final String fiscalQuarter;

  DepartmentBudgetItem({
    required this.id,
    required this.department,
    required this.totalBudget,
    required this.spentAmount,
    required this.fiscalQuarter,
  });

  double get percentage =>
      totalBudget > 0 ? (spentAmount / totalBudget).clamp(0.0, 1.5) : 0.0;
  double get remaining => totalBudget - spentAmount;
}

class VendorInvoiceItem {
  final String id;
  final String invoiceNumber;
  final String vendorName;
  final String issueDate;
  final String dueDate;
  final double amount;
  InvoiceStatus status;

  VendorInvoiceItem({
    required this.id,
    required this.invoiceNumber,
    required this.vendorName,
    required this.issueDate,
    required this.dueDate,
    required this.amount,
    required this.status,
  });
}

class FinanceViewBody extends StatefulWidget {
  const FinanceViewBody({super.key});

  @override
  State<FinanceViewBody> createState() => _FinanceViewBodyState();
}

class _FinanceViewBodyState extends State<FinanceViewBody> {
  FinanceTab _activeTab = FinanceTab.expenseClaims;

  // Search & Filter queries
  String _claimsSearchQuery = '';
  String _claimsStatusFilter = 'All Statuses';

  String _budgetSearchQuery = '';

  String _invoiceSearchQuery = '';
  String _invoiceStatusFilter = 'All Statuses';

  // State Data
  late List<ExpenseClaimItem> _claims;
  late List<DepartmentBudgetItem> _budgets;
  late List<VendorInvoiceItem> _invoices;

  @override
  void initState() {
    super.initState();
    _claims = [
      ExpenseClaimItem(
        id: '1',
        employeeName: 'Hassanv Khan',
        employeeEmail: 'hassankhan@hrm.com',
        category: 'Food',
        date: 'Aug 12',
        amount: 123456.00,
        status: ClaimStatus.pending,
        note: 'Team quarterly dinner & client catering',
      ),
      ExpenseClaimItem(
        id: '2',
        employeeName: 'N/A',
        employeeEmail: '',
        category: 'Food',
        date: 'Jul 20',
        amount: 64.00,
        status: ClaimStatus.approved,
        note: 'Client coffee & refreshments',
      ),
      ExpenseClaimItem(
        id: '3',
        employeeName: 'Sarah Jenkins',
        employeeEmail: 'sarah.j@hrm.com',
        category: 'Travel',
        date: 'Aug 10',
        amount: 340.00,
        status: ClaimStatus.approved,
        note: 'Flight ticket for regional tech conference',
      ),
      ExpenseClaimItem(
        id: '4',
        employeeName: 'Alex Rivera',
        employeeEmail: 'alex.r@hrm.com',
        category: 'Software',
        date: 'Aug 05',
        amount: 1200.00,
        status: ClaimStatus.rejected,
        note: 'Unauthorized enterprise tool subscription',
      ),
    ];

    _budgets = [
      DepartmentBudgetItem(
        id: '1',
        department: 'Engineering',
        totalBudget: 80000.00,
        spentAmount: 52000.00,
        fiscalQuarter: 'Q3 2026',
      ),
      DepartmentBudgetItem(
        id: '2',
        department: 'Marketing',
        totalBudget: 35000.00,
        spentAmount: 31500.00,
        fiscalQuarter: 'Q3 2026',
      ),
      DepartmentBudgetItem(
        id: '3',
        department: 'Sales',
        totalBudget: 50000.00,
        spentAmount: 28000.00,
        fiscalQuarter: 'Q3 2026',
      ),
      DepartmentBudgetItem(
        id: '4',
        department: 'Human Resources',
        totalBudget: 25000.00,
        spentAmount: 8500.00,
        fiscalQuarter: 'Q3 2026',
      ),
      DepartmentBudgetItem(
        id: '5',
        department: 'Design & Media',
        totalBudget: 15000.00,
        spentAmount: 6200.00,
        fiscalQuarter: 'Q3 2026',
      ),
    ];

    _invoices = [
      VendorInvoiceItem(
        id: '1',
        invoiceNumber: 'INV-2026-081',
        vendorName: 'AWS Cloud Hosting',
        issueDate: 'Aug 01, 2026',
        dueDate: 'Aug 25, 2026',
        amount: 1450.00,
        status: InvoiceStatus.unpaid,
      ),
      VendorInvoiceItem(
        id: '2',
        invoiceNumber: 'INV-2026-082',
        vendorName: 'WeWork Office Lease',
        issueDate: 'Aug 05, 2026',
        dueDate: 'Aug 30, 2026',
        amount: 3200.00,
        status: InvoiceStatus.unpaid,
      ),
      VendorInvoiceItem(
        id: '3',
        invoiceNumber: 'INV-2026-083',
        vendorName: 'Slack Technologies',
        issueDate: 'Jul 15, 2026',
        dueDate: 'Aug 10, 2026',
        amount: 480.00,
        status: InvoiceStatus.paid,
      ),
      VendorInvoiceItem(
        id: '4',
        invoiceNumber: 'INV-2026-084',
        vendorName: 'Google Workspace',
        issueDate: 'Jul 20, 2026',
        dueDate: 'Aug 05, 2026',
        amount: 720.00,
        status: InvoiceStatus.paid,
      ),
    ];
  }

  // Getters for Stats
  int get pendingApprovalsCount =>
      _claims.where((c) => c.status == ClaimStatus.pending).length;

  int get unpaidInvoicesCount =>
      _invoices.where((i) => i.status == InvoiceStatus.unpaid).length;

  double get totalBudgetAmount =>
      _budgets.fold(0.0, (sum, item) => sum + item.totalBudget);

  double get totalSpentAmount =>
      _budgets.fold(0.0, (sum, item) => sum + item.spentAmount);

  // Actions
  void _approveClaim(ExpenseClaimItem claim) {
    setState(() {
      claim.status = ClaimStatus.approved;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Expense claim of \$${_formatNumber(claim.amount)} approved successfully!',
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _rejectClaim(ExpenseClaimItem claim) {
    setState(() {
      claim.status = ClaimStatus.rejected;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Expense claim of \$${_formatNumber(claim.amount)} rejected.',
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _markInvoicePaid(VendorInvoiceItem invoice) {
    setState(() {
      invoice.status = InvoiceStatus.paid;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invoice ${invoice.invoiceNumber} marked as Paid!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showAddClaimDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String category = 'Food';

    showDialog(
      context: context,
      builder: (dialogCtx) {
        final theme = Theme.of(dialogCtx);
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: theme.cardColor,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: Color(0xFFF59E0B),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'New Expense Claim',
                    style: AppTextStyles.titleMedium,
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
                      Text('Employee Name', style: AppTextStyles.labelMedium),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameController,
                        decoration: _dialogInputDecoration(
                          theme,
                          'e.g. Hassan Khan',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Email Address', style: AppTextStyles.labelMedium),
                      const SizedBox(height: 6),
                      TextField(
                        controller: emailController,
                        decoration: _dialogInputDecoration(
                          theme,
                          'e.g. hassan@hrm.com',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Category',
                                  style: AppTextStyles.labelMedium,
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: category,
                                  items:
                                      [
                                            'Food',
                                            'Travel',
                                            'Software',
                                            'Office Supplies',
                                            'Equipment',
                                          ]
                                          .map(
                                            (cat) => DropdownMenuItem(
                                              value: cat,
                                              child: Text(cat),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setDialogState(() => category = val);
                                    }
                                  },
                                  decoration: _dialogInputDecoration(theme, ''),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Amount (\$)',
                                  style: AppTextStyles.labelMedium,
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: amountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  decoration: _dialogInputDecoration(
                                    theme,
                                    '0.00',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Description / Note',
                        style: AppTextStyles.labelMedium,
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: noteController,
                        maxLines: 2,
                        decoration: _dialogInputDecoration(
                          theme,
                          'Brief details regarding this expense...',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    final amount =
                        double.tryParse(amountController.text.trim()) ?? 0.0;
                    final name = nameController.text.trim().isEmpty
                        ? 'N/A'
                        : nameController.text.trim();
                    if (amount > 0) {
                      setState(() {
                        _claims.insert(
                          0,
                          ExpenseClaimItem(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            employeeName: name,
                            employeeEmail: emailController.text.trim(),
                            category: category,
                            date: 'Today',
                            amount: amount,
                            status: ClaimStatus.pending,
                            note: noteController.text.trim(),
                          ),
                        );
                      });
                      Navigator.of(dialogCtx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Expense claim submitted for approval!',
                          ),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Submit Claim'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddBudgetDialog() {
    final deptController = TextEditingController();
    final amountController = TextEditingController();
    final spentController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        final theme = Theme.of(dialogCtx);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: theme.cardColor,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Add Department Budget',
                style: AppTextStyles.titleMedium,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Department Name', style: AppTextStyles.labelMedium),
                  const SizedBox(height: 6),
                  TextField(
                    controller: deptController,
                    decoration: _dialogInputDecoration(
                      theme,
                      'e.g. Operations',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Total Budget (\$)', style: AppTextStyles.labelMedium),
                  const SizedBox(height: 6),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: _dialogInputDecoration(theme, 'e.g. 40000'),
                  ),
                  const SizedBox(height: 12),
                  Text('Initial Spent (\$)', style: AppTextStyles.labelMedium),
                  const SizedBox(height: 6),
                  TextField(
                    controller: spentController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: _dialogInputDecoration(theme, '0.00'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            FilledButton(
              onPressed: () {
                final dept = deptController.text.trim();
                final total =
                    double.tryParse(amountController.text.trim()) ?? 0.0;
                final spent =
                    double.tryParse(spentController.text.trim()) ?? 0.0;
                if (dept.isNotEmpty && total > 0) {
                  setState(() {
                    _budgets.add(
                      DepartmentBudgetItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        department: dept,
                        totalBudget: total,
                        spentAmount: spent,
                        fiscalQuarter: 'Q3 2026',
                      ),
                    );
                  });
                  Navigator.of(dialogCtx).pop();
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Add Budget'),
            ),
          ],
        );
      },
    );
  }

  void _showAddInvoiceDialog() {
    final vendorController = TextEditingController();
    final invNumberController = TextEditingController(
      text: 'INV-2026-0${_invoices.length + 80}',
    );
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        final theme = Theme.of(dialogCtx);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: theme.cardColor,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description_rounded,
                  color: AppColors.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Add Vendor Invoice',
                style: AppTextStyles.titleMedium,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invoice Number', style: AppTextStyles.labelMedium),
                  const SizedBox(height: 6),
                  TextField(
                    controller: invNumberController,
                    decoration: _dialogInputDecoration(
                      theme,
                      'e.g. INV-2026-085',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Vendor Name', style: AppTextStyles.labelMedium),
                  const SizedBox(height: 6),
                  TextField(
                    controller: vendorController,
                    decoration: _dialogInputDecoration(
                      theme,
                      'e.g. Microsoft 365',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Amount (\$)', style: AppTextStyles.labelMedium),
                  const SizedBox(height: 6),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: _dialogInputDecoration(theme, '0.00'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            FilledButton(
              onPressed: () {
                final vendor = vendorController.text.trim();
                final invNum = invNumberController.text.trim();
                final amount =
                    double.tryParse(amountController.text.trim()) ?? 0.0;
                if (vendor.isNotEmpty && amount > 0) {
                  setState(() {
                    _invoices.insert(
                      0,
                      VendorInvoiceItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        invoiceNumber: invNum.isEmpty ? 'INV-NEW' : invNum,
                        vendorName: vendor,
                        issueDate: 'Today',
                        dueDate: 'Net 30 Days',
                        amount: amount,
                        status: InvoiceStatus.unpaid,
                      ),
                    );
                  });
                  Navigator.of(dialogCtx).pop();
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save Invoice'),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _dialogInputDecoration(ThemeData theme, String hint) {
    return InputDecoration(
      hintText: hint,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FinanceHeader(
              onActionPressed: () {
                if (_activeTab == FinanceTab.budgets) {
                  _showAddBudgetDialog();
                } else if (_activeTab == FinanceTab.invoices) {
                  _showAddInvoiceDialog();
                } else {
                  _showAddClaimDialog();
                }
              },
              activeTab: _activeTab,
            ),
            const SizedBox(height: 16),
            _FinanceStatsRow(
              totalBudget: '\$165',
              utilizedBudget: '\$33',
              pendingApprovals: '$pendingApprovalsCount',
              totalClaims: '${_claims.length}',
              unpaidInvoices: '$unpaidInvoicesCount',
              totalInvoices: '${_invoices.length}',
            ),
            const SizedBox(height: 16),
            _FinanceNavigationTabs(
              activeTab: _activeTab,
              onTabChanged: (tab) => setState(() => _activeTab = tab),
            ),
            const SizedBox(height: 16),
            if (_activeTab == FinanceTab.expenseClaims)
              _ExpenseClaimsSection(
                claims: _filteredClaims,
                searchQuery: _claimsSearchQuery,
                statusFilter: _claimsStatusFilter,
                onSearchChanged: (q) => setState(() => _claimsSearchQuery = q),
                onStatusFilterChanged: (s) =>
                    setState(() => _claimsStatusFilter = s),
                onApprove: _approveClaim,
                onReject: _rejectClaim,
                onAddClaim: _showAddClaimDialog,
              )
            else if (_activeTab == FinanceTab.budgets)
              _BudgetsSection(
                budgets: _filteredBudgets,
                searchQuery: _budgetSearchQuery,
                onSearchChanged: (q) => setState(() => _budgetSearchQuery = q),
                onAddBudget: _showAddBudgetDialog,
              )
            else
              _InvoicesSection(
                invoices: _filteredInvoices,
                searchQuery: _invoiceSearchQuery,
                statusFilter: _invoiceStatusFilter,
                onSearchChanged: (q) => setState(() => _invoiceSearchQuery = q),
                onStatusFilterChanged: (s) =>
                    setState(() => _invoiceStatusFilter = s),
                onMarkPaid: _markInvoicePaid,
                onAddInvoice: _showAddInvoiceDialog,
              ),
          ],
        ),
      ),
    );
  }

  List<ExpenseClaimItem> get _filteredClaims {
    return _claims.where((c) {
      final matchesSearch =
          _claimsSearchQuery.isEmpty ||
          c.employeeName.toLowerCase().contains(
            _claimsSearchQuery.toLowerCase(),
          ) ||
          c.employeeEmail.toLowerCase().contains(
            _claimsSearchQuery.toLowerCase(),
          ) ||
          c.category.toLowerCase().contains(_claimsSearchQuery.toLowerCase());

      final matchesStatus =
          _claimsStatusFilter == 'All Statuses' ||
          (_claimsStatusFilter == 'Pending' &&
              c.status == ClaimStatus.pending) ||
          (_claimsStatusFilter == 'Approved' &&
              c.status == ClaimStatus.approved) ||
          (_claimsStatusFilter == 'Rejected' &&
              c.status == ClaimStatus.rejected);

      return matchesSearch && matchesStatus;
    }).toList();
  }

  List<DepartmentBudgetItem> get _filteredBudgets {
    return _budgets.where((b) {
      return _budgetSearchQuery.isEmpty ||
          b.department.toLowerCase().contains(_budgetSearchQuery.toLowerCase());
    }).toList();
  }

  List<VendorInvoiceItem> get _filteredInvoices {
    return _invoices.where((inv) {
      final matchesSearch =
          _invoiceSearchQuery.isEmpty ||
          inv.vendorName.toLowerCase().contains(
            _invoiceSearchQuery.toLowerCase(),
          ) ||
          inv.invoiceNumber.toLowerCase().contains(
            _invoiceSearchQuery.toLowerCase(),
          );

      final matchesStatus =
          _invoiceStatusFilter == 'All Statuses' ||
          (_invoiceStatusFilter == 'Unpaid' &&
              inv.status == InvoiceStatus.unpaid) ||
          (_invoiceStatusFilter == 'Paid' &&
              inv.status == InvoiceStatus.paid) ||
          (_invoiceStatusFilter == 'Overdue' &&
              inv.status == InvoiceStatus.overdue);

      return matchesSearch && matchesStatus;
    }).toList();
  }

  static String _formatNumber(double num) {
    if (num >= 1000) {
      final parts = num.toStringAsFixed(0).split('');
      String res = '';
      int count = 0;
      for (int i = parts.length - 1; i >= 0; i--) {
        res = parts[i] + res;
        count++;
        if (count % 3 == 0 && i > 0) {
          res = ',$res';
        }
      }
      return res;
    }
    return num.toStringAsFixed(0);
  }
}

// -------------------------------------------------------------
// 1. Finance Header
// -------------------------------------------------------------
class _FinanceHeader extends StatelessWidget {
  final VoidCallback onActionPressed;
  final FinanceTab activeTab;

  const _FinanceHeader({
    required this.onActionPressed,
    required this.activeTab,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String buttonLabel = 'Create Claim';
    IconData buttonIcon = Icons.add_rounded;
    Color buttonBg = const Color(0xFFF59E0B);

    if (activeTab == FinanceTab.budgets) {
      buttonLabel = 'Add Budget';
      buttonBg = AppColors.primary;
    } else if (activeTab == FinanceTab.invoices) {
      buttonLabel = 'New Invoice';
      buttonBg = AppColors.primary;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Teal/Emerald Gradient Icon Container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF10B981), // Emerald
                    Color(0xFF06B6D4), // Cyan
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withAlpha(60),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // Title, Admin Badge, and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Finance Management',
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontSize: isMobile ? 18 : 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurfaceVariant.withAlpha(
                            24,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Admin',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Manage departmental budgets, expense claims, and vendor invoices',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: isMobile ? 12 : 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            if (!isMobile) ...[
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: onActionPressed,
                icon: Icon(buttonIcon, size: 18),
                label: Text(buttonLabel),
                style: FilledButton.styleFrom(
                  backgroundColor: buttonBg,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

// -------------------------------------------------------------
// 2. Finance Stat Cards (Top Metric Cards)
// -------------------------------------------------------------
class _FinanceStatsRow extends StatelessWidget {
  final String totalBudget;
  final String utilizedBudget;
  final String pendingApprovals;
  final String totalClaims;
  final String unpaidInvoices;
  final String totalInvoices;

  const _FinanceStatsRow({
    required this.totalBudget,
    required this.utilizedBudget,
    required this.pendingApprovals,
    required this.totalClaims,
    required this.unpaidInvoices,
    required this.totalInvoices,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;

        final card1 = _FinanceStatCard(
          title: 'TOTAL BUDGET',
          value: totalBudget,
          subInfo: 'Utilized: $utilizedBudget',
          trendText: '8.5 vs last month',
          isTrendPositive: true,
          badgeColor: const Color(0xFF22C55E),
          badgeIcon: Icons.attach_money_rounded,
        );

        final card2 = _FinanceStatCard(
          title: 'PENDING APPROVALS',
          value: pendingApprovals,
          subInfo: 'Total Claims: $totalClaims',
          badgeColor: const Color(0xFFF59E0B),
          badgeIcon: Icons.request_quote_rounded,
        );

        final card3 = _FinanceStatCard(
          title: 'UNPAID INVOICES',
          value: unpaidInvoices,
          subInfo: 'Total Invoices: $totalInvoices',
          trendText: '3.2 vs last month',
          isTrendPositive: false,
          badgeColor: const Color(0xFFEF4444),
          badgeIcon: Icons.description_rounded,
        );

        if (isMobile) {
          return Column(
            children: [
              card1,
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: card2),
                  const SizedBox(width: 12),
                  Expanded(child: card3),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: card1),
            const SizedBox(width: 14),
            Expanded(child: card2),
            const SizedBox(width: 14),
            Expanded(child: card3),
          ],
        );
      },
    );
  }
}

class _FinanceStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subInfo;
  final String? trendText;
  final bool? isTrendPositive;
  final Color badgeColor;
  final IconData badgeIcon;

  const _FinanceStatCard({
    required this.title,
    required this.value,
    required this.subInfo,
    this.trendText,
    this.isTrendPositive,
    required this.badgeColor,
    required this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withAlpha(50), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Title & Badge Icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      value,
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: badgeColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(badgeIcon, color: badgeColor, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sub Info & Trend
          Text(
            subInfo,
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (trendText != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  isTrendPositive == true
                      ? Icons.arrow_outward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 14,
                  color: isTrendPositive == true
                      ? AppColors.success
                      : AppColors.error,
                ),
                const SizedBox(width: 4),
                Text(
                  trendText!,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isTrendPositive == true
                        ? AppColors.success
                        : AppColors.error,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 3. Finance Navigation Tabs (Pill Buttons)
// -------------------------------------------------------------
class _FinanceNavigationTabs extends StatelessWidget {
  final FinanceTab activeTab;
  final ValueChanged<FinanceTab> onTabChanged;

  const _FinanceNavigationTabs({
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _TabItem(
            label: 'Budgets',
            icon: Icons.folder_open_rounded,
            isSelected: activeTab == FinanceTab.budgets,
            onTap: () => onTabChanged(FinanceTab.budgets),
          ),
          const SizedBox(width: 10),
          _TabItem(
            label: 'Expense Claims',
            icon: Icons.receipt_long_rounded,
            hasSparkle: true,
            isSelected: activeTab == FinanceTab.expenseClaims,
            onTap: () => onTabChanged(FinanceTab.expenseClaims),
          ),
          const SizedBox(width: 10),
          _TabItem(
            label: 'Invoices',
            icon: Icons.description_outlined,
            isSelected: activeTab == FinanceTab.invoices,
            onTap: () => onTabChanged(FinanceTab.invoices),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool hasSparkle;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.icon,
    this.hasSparkle = false,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Selected style: Vibrant orange/amber gradient matching reference
    if (isSelected) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF59E0B), // Vibrant Amber
                Color(0xFFD97706), // Darker Amber
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF59E0B).withAlpha(60),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              if (hasSparkle) ...[
                const SizedBox(width: 6),
                const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
              ],
            ],
          ),
        ),
      );
    }

    // Inactive tab
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor.withAlpha(60)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 4. Tab 1: Expense Claims Section
// -------------------------------------------------------------
class _ExpenseClaimsSection extends StatelessWidget {
  final List<ExpenseClaimItem> claims;
  final String searchQuery;
  final String statusFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onStatusFilterChanged;
  final ValueChanged<ExpenseClaimItem> onApprove;
  final ValueChanged<ExpenseClaimItem> onReject;
  final VoidCallback onAddClaim;

  const _ExpenseClaimsSection({
    required this.claims,
    required this.searchQuery,
    required this.statusFilter,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
    required this.onApprove,
    required this.onReject,
    required this.onAddClaim,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dateString = '${now.month}/${now.day}/${now.year}';

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header Bar
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0EA5E9).withAlpha(24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.layers_rounded,
                        color: Color(0xFF0EA5E9),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Expense Claims',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0EA5E9).withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${claims.length} records',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: const Color(0xFF0284C7),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Last updated: $dateString',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search & Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 600;

                if (isCompact) {
                  return Column(
                    children: [
                      TextField(
                        onChanged: onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search employee or category...',
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: statusFilter,
                              items:
                                  [
                                        'All Statuses',
                                        'Pending',
                                        'Approved',
                                        'Rejected',
                                      ]
                                      .map(
                                        (s) => DropdownMenuItem(
                                          value: s,
                                          child: Text(s),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) {
                                if (val != null) onStatusFilterChanged(val);
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surface,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: theme.dividerColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            onPressed: onAddClaim,
                            icon: const Icon(Icons.add_rounded),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFFF59E0B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        onChanged: onSearchChanged,
                        decoration: InputDecoration(
                          hintText:
                              'Search by employee name, email or category...',
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        initialValue: statusFilter,
                        items:
                            ['All Statuses', 'Pending', 'Approved', 'Rejected']
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          if (val != null) onStatusFilterChanged(val);
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: onAddClaim,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Add Claim'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Horizontal scrollable table wrapper to support all screen widths
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 720),
              child: SizedBox(
                width: MediaQuery.of(context).size.width.clamp(720.0, 3000.0),
                child: Column(
                  children: [
                    // Custom Green Header Row matching reference image
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF22C55E,
                        ).withAlpha(16), // Light green tint
                        border: Border(
                          top: BorderSide(
                            color: const Color(0xFF22C55E).withAlpha(30),
                          ),
                          bottom: BorderSide(
                            color: const Color(0xFF22C55E).withAlpha(30),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'EMPLOYEE',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: const Color(0xFF16A34A),
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'CATEGORY / DATE',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: const Color(0xFF16A34A),
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'AMOUNT',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: const Color(0xFF16A34A),
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'STATUS',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: const Color(0xFF16A34A),
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'ACTIONS',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: const Color(0xFF16A34A),
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Table Rows List
                    if (claims.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant
                                    .withAlpha(100),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No expense claims found',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: claims.length,
                        separatorBuilder: (ctx, idx) => Divider(
                          height: 1,
                          color: theme.dividerColor.withAlpha(40),
                        ),
                        itemBuilder: (context, index) {
                          final claim = claims[index];
                          return _ExpenseClaimRow(
                            claim: claim,
                            onApprove: () => onApprove(claim),
                            onReject: () => onReject(claim),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseClaimRow extends StatelessWidget {
  final ExpenseClaimItem claim;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ExpenseClaimRow({
    required this.claim,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // 1. Employee
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  claim.employeeName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
                if (claim.employeeEmail.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    claim.employeeEmail,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 2. Category / Date
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  claim.category,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  claim.date,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // 3. Amount
          Expanded(
            flex: 2,
            child: Text(
              '\$${_FinanceViewBodyState._formatNumber(claim.amount)}',
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),

          // 4. Status Badge
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _StatusChip(status: claim.status),
            ),
          ),

          // 5. Actions (Approve / Reject Buttons)
          Expanded(
            flex: 3,
            child: claim.status == ClaimStatus.pending
                ? Row(
                    children: [
                      // Approve Button (Green)
                      FilledButton.icon(
                        onPressed: onApprove,
                        icon: const Icon(Icons.check_rounded, size: 16),
                        label: const Text('Approve'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Reject Button (Red)
                      FilledButton.icon(
                        onPressed: onReject,
                        icon: const Icon(Icons.cancel_outlined, size: 16),
                        label: const Text('Reject'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final ClaimStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color text;
    IconData icon;
    String label;

    switch (status) {
      case ClaimStatus.pending:
        bg = const Color(0xFFFEF3C7);
        border = const Color(0xFFFDE68A);
        text = const Color(0xFFD97706);
        icon = Icons.schedule_rounded;
        label = 'Pending';
        break;
      case ClaimStatus.approved:
        bg = const Color(0xFFDCFCE7);
        border = const Color(0xFFBBF7D0);
        text = const Color(0xFF16A34A);
        icon = Icons.check_circle_outline_rounded;
        label = 'Approved';
        break;
      case ClaimStatus.rejected:
        bg = const Color(0xFFFEE2E2);
        border = const Color(0xFFFECACA);
        text = const Color(0xFFDC2626);
        icon = Icons.cancel_outlined;
        label = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: text),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: text,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 5. Tab 2: Budgets Section
// -------------------------------------------------------------
class _BudgetsSection extends StatelessWidget {
  final List<DepartmentBudgetItem> budgets;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAddBudget;

  const _BudgetsSection({
    required this.budgets,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onAddBudget,
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
            color: theme.shadowColor.withAlpha(12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Departmental Budgets',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${budgets.length} departments',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: onAddBudget,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Allocate Budget'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search department...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Department Budget Cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            itemCount: budgets.length,
            separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final b = budgets[index];
              return _DepartmentBudgetCard(item: b);
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _DepartmentBudgetCard extends StatelessWidget {
  final DepartmentBudgetItem item;

  const _DepartmentBudgetCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (item.percentage * 100).toInt();

    Color progressColor = AppColors.success;
    String statusText = 'On Track';
    Color statusBg = const Color(0xFFDCFCE7);
    Color statusFg = const Color(0xFF16A34A);

    if (item.percentage >= 0.9 && item.percentage <= 1.0) {
      progressColor = const Color(0xFFF59E0B);
      statusText = 'Near Limit';
      statusBg = const Color(0xFFFEF3C7);
      statusFg = const Color(0xFFD97706);
    } else if (item.percentage > 1.0) {
      progressColor = AppColors.error;
      statusText = 'Over Budget';
      statusBg = const Color(0xFFFEE2E2);
      statusFg = const Color(0xFFDC2626);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    item.department,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item.fiscalQuarter,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusFg,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: item.percentage.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: theme.dividerColor.withAlpha(50),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          const SizedBox(height: 12),

          // Budget Numbers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: \$${_FinanceViewBodyState._formatNumber(item.spentAmount)} ($percent%)',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                  fontSize: 13,
                ),
              ),
              Text(
                'Total: \$${_FinanceViewBodyState._formatNumber(item.totalBudget)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 6. Tab 3: Vendor Invoices Section
// -------------------------------------------------------------
class _InvoicesSection extends StatelessWidget {
  final List<VendorInvoiceItem> invoices;
  final String searchQuery;
  final String statusFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onStatusFilterChanged;
  final ValueChanged<VendorInvoiceItem> onMarkPaid;
  final VoidCallback onAddInvoice;

  const _InvoicesSection({
    required this.invoices,
    required this.searchQuery,
    required this.statusFilter,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
    required this.onMarkPaid,
    required this.onAddInvoice,
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
            color: theme.shadowColor.withAlpha(12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.error.withAlpha(24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.description_rounded,
                        color: AppColors.error,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Vendor Invoices',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${invoices.length} invoices',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: onAddInvoice,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add Invoice'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search vendor or invoice #...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    initialValue: statusFilter,
                    items: ['All Statuses', 'Unpaid', 'Paid', 'Overdue']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) onStatusFilterChanged(val);
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Invoices Table wrapped with horizontal scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 700),
              child: SizedBox(
                width: MediaQuery.of(context).size.width.clamp(700.0, 3000.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: invoices.length,
                  separatorBuilder: (ctx, idx) => Divider(
                    height: 1,
                    color: theme.dividerColor.withAlpha(40),
                  ),
                  itemBuilder: (context, index) {
                    final inv = invoices[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  inv.vendorName,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  inv.invoiceNumber,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Due: ${inv.dueDate}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '\$${_FinanceViewBodyState._formatNumber(inv.amount)}',
                              style: AppTextStyles.headlineMedium.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: _InvoiceStatusChip(status: inv.status),
                          ),
                          Expanded(
                            flex: 2,
                            child: inv.status == InvoiceStatus.unpaid
                                ? TextButton.icon(
                                    onPressed: () => onMarkPaid(inv),
                                    icon: const Icon(
                                      Icons.check_rounded,
                                      size: 16,
                                    ),
                                    label: const Text('Mark Paid'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.success,
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceStatusChip extends StatelessWidget {
  final InvoiceStatus status;

  const _InvoiceStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case InvoiceStatus.unpaid:
        bg = const Color(0xFFFEE2E2);
        text = const Color(0xFFDC2626);
        label = 'Unpaid';
        break;
      case InvoiceStatus.paid:
        bg = const Color(0xFFDCFCE7);
        text = const Color(0xFF16A34A);
        label = 'Paid';
        break;
      case InvoiceStatus.overdue:
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFFD97706);
        label = 'Overdue';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
