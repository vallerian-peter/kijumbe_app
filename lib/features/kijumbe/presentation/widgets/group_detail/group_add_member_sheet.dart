import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class GroupAddMemberSheet extends StatefulWidget {
  final bool isDark;
  final ValueChanged<String> onAddMember;

  const GroupAddMemberSheet({
    super.key,
    required this.isDark,
    required this.onAddMember,
  });

  static void show(
    BuildContext context, {
    required bool isDark,
    required ValueChanged<String> onAddMember,
  }) {
    final sheetBg = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => GroupAddMemberSheet(
        isDark: isDark,
        onAddMember: onAddMember,
      ),
    );
  }

  @override
  State<GroupAddMemberSheet> createState() => _GroupAddMemberSheetState();
}

class _GroupAddMemberSheetState extends State<GroupAddMemberSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = widget.isDark;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n?.addMember ?? 'Add New Member',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Enter the member\'s phone number to invite them.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: isDark ? Colors.white54 : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          // Phone field
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.07)
                  : AppColors.appGreyWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: isDark ? Colors.white24 : Colors.grey.shade200,
                  width: 1),
            ),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              autofocus: true,
              style: TextStyle(
                fontFamily: 'Inter',
                color: isDark ? Colors.white : AppColors.blackColor,
              ),
              decoration: InputDecoration(
                hintText: '+255 7XX XXX XXX',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  color: isDark ? Colors.white38 : Colors.grey.shade400,
                ),
                prefixIcon: const Icon(Icons.phone_outlined,
                    color: AppColors.primaryColor, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Invite button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  widget.onAddMember(text);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n?.sendOtp ?? 'Send Invitation',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
