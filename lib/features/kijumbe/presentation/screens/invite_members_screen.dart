import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/components/custom_back_button.dart';
import 'package:kijumbe_app/core/components/custom_phone_number_field.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class InvitedMemberItem {
  final String username;
  final String phoneNumber;
  final String generatedLink;
  final DateTime invitedAt;

  InvitedMemberItem({
    required this.username,
    required this.phoneNumber,
    required this.generatedLink,
    required this.invitedAt,
  });
}

class InviteMembersScreen extends StatefulWidget {
  final GroupData? group;
  final String? inviteCode;

  const InviteMembersScreen({
    super.key,
    this.group,
    this.inviteCode,
  });

  @override
  State<InviteMembersScreen> createState() => _InviteMembersScreenState();
}

class _InviteMembersScreenState extends State<InviteMembersScreen> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _completePhoneNumber = '';

  late String _groupCode;
  late String _baseInviteLink;

  final List<InvitedMemberItem> _invitedMembers = [];

  @override
  void initState() {
    super.initState();
    final name = widget.group?.name ?? 'FAM';
    final initials = name
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toUpperCase();
    final prefix = initials.length >= 3 ? initials.substring(0, 3) : 'FAM';
    _groupCode = widget.inviteCode ?? '${prefix}2026';
    _baseInviteLink = 'https://kijumbe.app/join/$_groupCode';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    final l10n = AppLocalizations.of(context);
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n?.copiedToClipboard(label) ?? '$label copied to clipboard!',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleAddMember() {
    final l10n = AppLocalizations.of(context);
    final username = _usernameController.text.trim();
    final phone = _completePhoneNumber.isNotEmpty
        ? _completePhoneNumber
        : _phoneController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n?.pleaseEnterMemberUsername ?? 'Please enter member username',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n?.pleaseEnterMemberPhone ??
                'Please enter member phone number',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final sanitizedUser = Uri.encodeComponent(username.replaceAll('@', ''));
    final sanitizedPhone = Uri.encodeComponent(phone.replaceAll(' ', ''));
    final personalLink =
        '$_baseInviteLink?user=$sanitizedUser&phone=$sanitizedPhone';

    setState(() {
      _invitedMembers.insert(
        0,
        InvitedMemberItem(
          username: username.startsWith('@') ? username : '@$username',
          phoneNumber: phone,
          generatedLink: personalLink,
          invitedAt: DateTime.now(),
        ),
      );
      _usernameController.clear();
      _phoneController.clear();
      _completePhoneNumber = '';
    });

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n?.personalInviteGenerated(username) ??
              'Personal invite link generated for $username!',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final bgColor = isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite;
    final cardBg = isDark ? const Color(0xFF3D3D3D) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CustomBackButton(
            iconColor: isDark ? Colors.white : AppColors.blackColor,
            bgColor: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.05),
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          l10n?.inviteMembers ?? 'Invite members',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.blackColor,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Top Circular Avatar & Hero ────────────────────────────────
              const SizedBox(height: 8),
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withValues(alpha: 0.12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.groups_rounded,
                    size: 46,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n?.growYourCircle ?? 'Grow Your Circle',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.blackColor,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Invite trusted friends and family to join your savings group',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // ── Card 1: Share invite link ─────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share invite link',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Anyone with this link can join your group',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Link Box
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _baseInviteLink,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.white70
                                    : Colors.grey.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.copy_rounded,
                              size: 18,
                              color: AppColors.primaryColor,
                            ),
                            tooltip: 'Copy link',
                            onPressed: () => _copyToClipboard(
                                _baseInviteLink, 'Invite link'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 3 Quick Share Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildShareButton(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            isDark: isDark,
                            onTap: () => _copyToClipboard(
                                'Join our Kijumbe group circle via: $_baseInviteLink',
                                'Email invitation'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildShareButton(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: 'Message',
                            isDark: isDark,
                            onTap: () => _copyToClipboard(
                                'Habari! Join our Kijumbe savings circle: $_baseInviteLink',
                                'SMS message'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildShareButton(
                            icon: Icons.share_outlined,
                            label: 'Share',
                            isDark: isDark,
                            onTap: () => _copyToClipboard(
                                _baseInviteLink, 'Invite link'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Card 2: Invite code ───────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite code',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Share this code for members to join manually',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () =>
                          _copyToClipboard(_groupCode, 'Invite code'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primaryColor
                                .withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _groupCode,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryColor,
                                letterSpacing: 2.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Card 3: Add Member by Username & Phone (User Feature) ─────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Add member directly',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.blackColor,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Kijumbe',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Enter member username and phone number to generate a personal invite link',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Username input
                    TextField(
                      controller: _usernameController,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: isDark ? Colors.white : AppColors.blackColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Member Username (e.g. juma_k)',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: isDark ? Colors.white38 : Colors.grey.shade400,
                        ),
                        prefixIcon: const Icon(
                          Iconsax.user_outline,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.03),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.06),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.06),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Phone Number input
                    CustomPhoneNumberField(
                      controller: _phoneController,
                      isDark: isDark,
                      hintText: '712 345 678',
                      onChanged: (phone) {
                        _completePhoneNumber = phone.completeNumber;
                      },
                    ),
                    const SizedBox(height: 14),
                    // Generate Link Button
                    GestureDetector(
                      onTap: _handleAddMember,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryButtonGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor
                                  .withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.link_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Generate & Add Member',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Generated Members List
                    if (_invitedMembers.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Divider(
                        height: 1,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.06),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Generated Member Links (${_invitedMembers.length})',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _invitedMembers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) {
                          final member = _invitedMembers[i];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : Colors.black.withValues(alpha: 0.02),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.07)
                                    : Colors.black.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppColors.primaryColor
                                          .withValues(alpha: 0.15),
                                      child: Text(
                                        member.username.length > 1
                                            ? member.username[1].toUpperCase()
                                            : 'U',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            member.username,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: isDark
                                                  ? Colors.white
                                                  : AppColors.blackColor,
                                            ),
                                          ),
                                          Text(
                                            member.phoneNumber,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 11,
                                              color: isDark
                                                  ? Colors.white54
                                                  : Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.greenColor
                                            .withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Ready',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.greenColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        member.generatedLink,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11,
                                          color: AppColors.primaryColor,
                                          decoration:
                                              TextDecoration.underline,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => _copyToClipboard(
                                          member.generatedLink,
                                          'Personal link for ${member.username}'),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.copy_rounded,
                                                size: 13,
                                                color: AppColors.primaryColor),
                                            SizedBox(width: 4),
                                            Text(
                                              'Copy',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Skip / Done Button ────────────────────────────────────────
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Skip for now',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: isDark ? Colors.white70 : AppColors.blackColor,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
