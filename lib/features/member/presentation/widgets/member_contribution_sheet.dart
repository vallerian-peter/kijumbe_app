import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/components/custom_button.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

/// Clean payment modal sheet for a member to make their group contribution
/// via Mobile Money (M-Pesa, Tigo Pesa, Airtel Money, HaloPesa).
class MemberContributionSheet extends StatefulWidget {
  final GroupData group;
  final String memberPhone;

  const MemberContributionSheet({
    super.key,
    required this.group,
    this.memberPhone = '+255 712 345 678',
  });

  static Future<bool?> show(
    BuildContext context, {
    required GroupData group,
    String memberPhone = '+255 712 345 678',
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: MemberContributionSheet(
          group: group,
          memberPhone: memberPhone,
        ),
      ),
    );
  }

  @override
  State<MemberContributionSheet> createState() =>
      _MemberContributionSheetState();
}

class _MemberContributionSheetState extends State<MemberContributionSheet> {
  int _selectedOperator = 0; // 0: M-Pesa, 1: Tigo Pesa, 2: Airtel Money, 3: HaloPesa
  bool _isProcessing = false;
  late final TextEditingController _phoneController;

  final List<Map<String, dynamic>> _operators = [
    {
      'name': 'M-Pesa',
      'color': const Color(0xFFE60000),
      'prefix': 'Vodacom',
    },
    {
      'name': 'Tigo Pesa',
      'color': const Color(0xFF00377B),
      'prefix': 'Yas / Tigo',
    },
    {
      'name': 'Airtel Money',
      'color': const Color(0xFFFF0000),
      'prefix': 'Airtel',
    },
    {
      'name': 'HaloPesa',
      'color': const Color(0xFFFF6600),
      'prefix': 'Halotel',
    },
  ];

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.memberPhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    setState(() => _isProcessing = false);
    Navigator.of(context).pop(true);

    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n?.contributionSuccessful ??
                    'Contribution submitted successfully!',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.greenColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final sheetBg = isDark ? const Color(0xFF1E232A) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.15),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title Header
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.greenColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: AppColors.greenColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.makeContribution ?? 'Make Contribution',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.blackColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.group.name,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Amount Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? LinearGradient(
                          colors: [
                            const Color(0xFF252D37),
                            const Color(0xFF1E232A),
                          ],
                        )
                      : const LinearGradient(
                          colors: [
                            Color(0xFFF0FDF4),
                            Color(0xFFE8F5E9),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.greenColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n?.contributionAmount ?? 'Contribution Amount',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white60 : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.group.contribution,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.greenColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Round ${widget.group.currentRound} • ${widget.group.frequency}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: isDark ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Operator Selection
              Text(
                l10n?.selectMobileMoneyOperator ??
                    'Select Mobile Money Operator',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: List.generate(_operators.length, (index) {
                  final op = _operators[index];
                  final isSelected = _selectedOperator == index;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 4,
                        right: index == _operators.length - 1 ? 0 : 4,
                      ),
                      child: InkWell(
                        onTap: () => setState(() => _selectedOperator = index),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (op['color'] as Color).withValues(alpha: 0.12)
                                : isDark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : const Color(0xFFF6F8FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? (op['color'] as Color)
                                  : isDark
                                      ? Colors.white12
                                      : Colors.grey[300]!,
                              width: isSelected ? 1.8 : 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: op['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.phone_android_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                op['name'] as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 18),

              // Phone Number field
              Text(
                l10n?.mobileMoneyNumber ?? 'Mobile Money Number',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.blackColor,
                ),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.phone_rounded,
                    color: AppColors.appPrimaryColor,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : const Color(0xFFF6F8FA),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white12 : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white12 : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.appPrimaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Pay button
              CustomButton(
                text: '${l10n?.contributeNow ?? 'Contribute Now'} (${widget.group.contribution})',
                height: 52,
                borderRadius: 14,
                isLoading: _isProcessing,
                onPressed: _handlePayment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
