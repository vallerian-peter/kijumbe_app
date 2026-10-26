import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/components/custom_alert_dialog.dart';
import 'package:kijumbe_app/core/components/custom_button.dart';
import 'package:kijumbe_app/core/components/custom_toast.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

/// Modal bottom sheet allowing the Kijumbe Leader (the group controller)
/// to swap payout turns between two members in their circle.
class KijumbeSwapTurnsSheet extends StatefulWidget {
  final GroupData group;
  final List<MemberData> members;
  final void Function(MemberData memberA, MemberData memberB)? onTurnsSwapped;

  const KijumbeSwapTurnsSheet({
    super.key,
    required this.group,
    required this.members,
    this.onTurnsSwapped,
  });

  static Future<bool?> show(
    BuildContext context, {
    required GroupData group,
    required List<MemberData> members,
    void Function(MemberData memberA, MemberData memberB)? onTurnsSwapped,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: KijumbeSwapTurnsSheet(
          group: group,
          members: members,
          onTurnsSwapped: onTurnsSwapped,
        ),
      ),
    );
  }

  @override
  State<KijumbeSwapTurnsSheet> createState() => _KijumbeSwapTurnsSheetState();
}

class _KijumbeSwapTurnsSheetState extends State<KijumbeSwapTurnsSheet> {
  MemberData? _firstMember;
  MemberData? _secondMember;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    if (widget.members.isNotEmpty) {
      _firstMember = widget.members.first;
    }
    if (widget.members.length > 1) {
      _secondMember = widget.members[1];
    }
  }

  Future<void> _handleSwap() async {
    if (_firstMember == null || _secondMember == null) return;
    if (_firstMember!.name == _secondMember!.name) {
      final isSw = Localizations.localeOf(context).languageCode == 'sw';
      CustomToast.showWarning(
        context,
        isSw
            ? 'Tafadhali chagua wanachama wawili tofauti'
            : 'Please select two different members to swap turns',
      );
      return;
    }

    final l10n = AppLocalizations.of(context);
    final isSw = Localizations.localeOf(context).languageCode == 'sw';

    final confirmed = await ConfirmationAlertDialog.show(
      context,
      type: AlertType.warning,
      title: l10n?.swapMemberTurns ?? 'Swap Member Turns',
      message: isSw
          ? 'Je, una uhakika unataka kubadilisha Zamu #${_firstMember!.payoutOrder} (${_firstMember!.name}) na Zamu #${_secondMember!.payoutOrder} (${_secondMember!.name})?'
          : 'Are you sure you want to swap Turn #${_firstMember!.payoutOrder} (${_firstMember!.name}) with Turn #${_secondMember!.payoutOrder} (${_secondMember!.name})?',
      confirmText: l10n?.confirmSwapTurns ?? 'Confirm & Swap',
      cancelText: l10n?.cancel ?? 'Cancel',
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    widget.onTurnsSwapped?.call(_firstMember!, _secondMember!);

    setState(() => _isProcessing = false);
    Navigator.of(context).pop(true);

    CustomToast.showSuccess(
      context,
      l10n?.swapTurnsSuccess ??
          (isSw
              ? 'Zamu zimebadilishwa kikamilifu!'
              : 'Turns swapped successfully between members!'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isSw = Localizations.localeOf(context).languageCode == 'sw';
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
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag handle
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

              // Header Row
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.swap_vert_rounded,
                      color: AppColors.primaryColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.swapMemberTurns ?? 'Swap Member Turns',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.blackColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n?.swapMemberTurnsSubtitle ??
                              'Reorder payout turns between two group members',
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

              const SizedBox(height: 18),

              // Controller Note Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.blue.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white12
                        : Colors.blue.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 18,
                      color: isDark ? Colors.white70 : AppColors.appPrimaryColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isSw
                            ? 'Wewe ndiye msimamizi (Kijumbe) wa kikundi hiki. Una mamlaka ya kubadilisha zamu za kupokea kati ya wanachama.'
                            : 'As the group leader (Kijumbe), you are the controller authorized to reorder or swap payout turns between members.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          height: 1.35,
                          color: isDark ? Colors.white70 : Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Member 1 Selector
              Text(
                l10n?.selectFirstMember ?? 'Select First Member',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              _buildMemberDropdown(
                value: _firstMember,
                onChanged: (val) => setState(() => _firstMember = val),
                isDark: isDark,
              ),

              const SizedBox(height: 12),

              // Swap Divider Icon
              Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.swap_vert_rounded,
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Member 2 Selector
              Text(
                l10n?.selectSecondMember ?? 'Select Second Member',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              _buildMemberDropdown(
                value: _secondMember,
                onChanged: (val) => setState(() => _secondMember = val),
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // Swap Preview Card
              if (_firstMember != null && _secondMember != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFF6F8FA),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey[200]!,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            _firstMember!.name,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: isDark ? Colors.white : AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Turn #${_firstMember!.payoutOrder} → #${_secondMember!.payoutOrder}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.appPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.swap_horiz_rounded,
                        color: AppColors.primaryColor,
                        size: 24,
                      ),
                      Column(
                        children: [
                          Text(
                            _secondMember!.name,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: isDark ? Colors.white : AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Turn #${_secondMember!.payoutOrder} → #${_firstMember!.payoutOrder}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.appPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Confirm & Swap Button
              CustomButton(
                text: l10n?.confirmSwapTurns ?? 'Confirm & Swap Turns',
                height: 52,
                borderRadius: 14,
                isLoading: _isProcessing,
                onPressed: _handleSwap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberDropdown({
    required MemberData? value,
    required ValueChanged<MemberData?> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey[300]!,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MemberData>(
          value: value,
          isExpanded: true,
          dropdownColor: isDark ? const Color(0xFF22272E) : Colors.white,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          items: widget.members.map((member) {
            return DropdownMenuItem<MemberData>(
              value: member,
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: member.avatarColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      member.name[0],
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${member.name} (Turn #${member.payoutOrder})',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.blackColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
