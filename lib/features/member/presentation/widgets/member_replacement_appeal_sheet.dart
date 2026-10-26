import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/components/custom_alert_dialog.dart';
import 'package:kijumbe_app/core/components/custom_button.dart';
import 'package:kijumbe_app/core/components/custom_toast.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

/// Modal bottom sheet allowing a Member to submit a Replacement Appeal.
/// Because the Kijumbe Leader is the controller responsible for swapping turns,
/// the Member appeals to be removed/replaced, and the leader then swaps with another member.
class MemberReplacementAppealSheet extends StatefulWidget {
  final GroupData group;
  final MemberData currentMember;

  const MemberReplacementAppealSheet({
    super.key,
    required this.group,
    required this.currentMember,
  });

  static Future<bool?> show(
    BuildContext context, {
    required GroupData group,
    required MemberData currentMember,
    List<MemberData>? members, // optional backward-compatibility parameter
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: MemberReplacementAppealSheet(
          group: group,
          currentMember: currentMember,
        ),
      ),
    );
  }

  @override
  State<MemberReplacementAppealSheet> createState() =>
      _MemberReplacementAppealSheetState();
}

class _MemberReplacementAppealSheetState
    extends State<MemberReplacementAppealSheet> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitAppeal() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context);
    final isSw = Localizations.localeOf(context).languageCode == 'sw';
    final leaderName = widget.group.kijumbeName;

    // Show Confirmation Dialog before submission
    final confirmed = await ConfirmationAlertDialog.show(
      context,
      type: AlertType.warning,
      title: l10n?.replacementAppeal ??
          (isSw ? 'Ombi la Kubadilishwa' : 'Replacement Appeal'),
      message: isSw
          ? 'Je, una uhakika unataka kuwasilisha Ombi la Kubadilishwa kwa Kijumbe ($leaderName)? Unaomba kuondolewa ili Kijumbe abadilishe zamu yako na mwanachama mwingine.'
          : 'Are you sure you want to submit a Replacement Appeal to your Kijumbe Leader ($leaderName)? You are requesting to be removed/replaced so the leader can swap your turn with another member.',
      confirmText: l10n?.submitAppeal ?? (isSw ? 'Tuma Ombi' : 'Submit Appeal'),
      cancelText: l10n?.cancel ?? (isSw ? 'Ghairi' : 'Cancel'),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    setState(() => _isSubmitting = false);
    Navigator.of(context).pop(true);

    CustomToast.showSuccess(
      context,
      l10n?.replacementSubmitted ??
          (isSw
              ? 'Ombi lako la kubadilishwa limetumwa kwa Kijumbe wako ($leaderName).'
              : 'Your replacement appeal has been submitted to your Kijumbe Leader ($leaderName).'),
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
          child: Form(
            key: _formKey,
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

                // Icon & Header
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.appPrimaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.person_remove_rounded,
                        color: AppColors.appPrimaryColor,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n?.replacementAppeal ??
                                (isSw
                                    ? 'Ombi la Kubadilishwa'
                                    : 'Replacement Appeal'),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n?.replacementAppealSubtitle ??
                                (isSw
                                    ? 'Omba Kijumbe kubadilisha zamu yako na mwanachama mwingine'
                                    : 'Request your Kijumbe Leader to replace you in this circle'),
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

                // Current Turn Display Card
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
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: widget.currentMember.avatarColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.currentMember.name[0],
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isSw
                                  ? 'Zamu Yako: #${widget.currentMember.payoutOrder}'
                                  : 'Your Assigned Turn: #${widget.currentMember.payoutOrder}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : AppColors.blackColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.group.name} • Kijumbe: ${widget.group.kijumbeName}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: isDark ? Colors.white54 : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.appPrimaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Turn #${widget.currentMember.payoutOrder}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.appPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Notice Box: Explaining Role of Kijumbe vs Member
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : Colors.orange.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.white12
                          : Colors.orange.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: isDark ? Colors.orange.shade300 : Colors.orange.shade800,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isSw
                              ? 'Kumbuka: Kijumbe ndiye mwenye jukumu la kubadilisha zamu za kikundi. Ukiwasilisha ombi hili la kubadilishwa, Kijumbe wako (${widget.group.kijumbeName}) atapokea taarifa na kukutafutia mwanachama mbadala.'
                              : 'Note: As the controller, your Kijumbe Leader (${widget.group.kijumbeName}) is responsible for reordering turns. Submitting this appeal requests the leader to replace you and assign your turn to another member.',
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

                // Reason Input Field
                Text(
                  l10n?.reasonForReplacement ??
                      (isSw
                          ? 'Sababu ya Ombi la Kubadilishwa'
                          : 'Reason for Replacement Appeal'),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _reasonController,
                  maxLines: 3,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: isDark ? Colors.white : AppColors.blackColor,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n?.reasonForReplacementHint ??
                        (isSw
                            ? 'Eleza sababu yako (mf. Dharura ya kifedha, kuhama, kushindwa kuendelea)'
                            : 'State your reason (e.g. Financial emergency, unable to continue contributions)'),
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: isDark ? Colors.white38 : Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFF6F8FA),
                    contentPadding: const EdgeInsets.all(14),
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
                  validator: (value) {
                    if (value == null || value.trim().length < 5) {
                      return isSw
                          ? 'Tafadhali weka sababu halali ya ombi hili'
                          : 'Please enter a valid reason for this appeal';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Submit Button
                CustomButton(
                  text: l10n?.submitAppeal ??
                      (isSw ? 'Tuma Ombi la Kubadilishwa' : 'Submit Replacement Appeal'),
                  height: 52,
                  borderRadius: 14,
                  isLoading: _isSubmitting,
                  onPressed: _submitAppeal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
