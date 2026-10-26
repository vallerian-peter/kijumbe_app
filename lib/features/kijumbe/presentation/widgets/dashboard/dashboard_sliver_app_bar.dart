import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_profile_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/dashboard/dashboard_models.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class DashboardSliverAppBar extends StatelessWidget {
  final String kijumbeName;
  final String totalBalance;
  final String? balanceTitle;
  final String? appSubtitle;
  final int pendingActions;
  final List<DashboardQuickAction> quickActions;
  final bool isDark;
  final VoidCallback? onAvatarTap;

  const DashboardSliverAppBar({
    super.key,
    required this.kijumbeName,
    required this.totalBalance,
    this.balanceTitle,
    this.appSubtitle,
    required this.pendingActions,
    required this.quickActions,
    required this.isDark,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 282,
      collapsedHeight: 72,
      floating: false,
      pinned: true,
      snap: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: LayoutBuilder(
        builder: (ctx, constraints) {
          const double maxH = 282;
          const double minH = 72;
          final double ratio =
              ((constraints.maxHeight - minH) / (maxH - minH)).clamp(0.0, 1.0);
          final bool isCollapsed = ratio < 0.22;
          return FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: _buildExpandedHeader(context),
            title: isCollapsed ? _buildCollapsedBar(context) : null,
            titlePadding: EdgeInsets.zero,
          );
        },
      ),
    );
  }

  Widget _buildExpandedHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryTealGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onAvatarTap ??
                        () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const KijumbeProfileScreen(),
                              ),
                            ),
                    child: _buildKijumbeAvatar(size: 46),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(text: '${l10n?.goodMorning ?? 'Hello'}, '),
                              TextSpan(
                                text: kijumbeName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800),
                              ),
                              const TextSpan(text: ' 👋'),
                            ],
                          ),
                        ),
                        const Text(
                          'Kijumbe Dashboard',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildNotificationBell(),
                ],
              ),
              const SizedBox(height: 16),
              _buildBalanceCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryTealGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            _buildKijumbeAvatar(size: 36),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${l10n?.goodMorning ?? 'Hello'}, $kijumbeName',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            _buildNotificationBell(),
          ],
        ),
      ),
    );
  }

  Widget _buildKijumbeAvatar({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.25),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.appPrimaryDarkColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.4),
                    Colors.white.withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: Text(
                kijumbeName.isNotEmpty ? kijumbeName[0].toUpperCase() : 'K',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: size * 0.38,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationBell() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3), width: 1),
            ),
            child: const Icon(Icons.notifications_outlined,
                color: Colors.white, size: 20),
          ),
        ),
        if (pendingActions > 0)
          Positioned(
            top: -3,
            right: -3,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4757),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Center(
                child: Text(
                  '$pendingActions',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 7.5,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                balanceTitle ?? (l10n?.totalBalance ?? 'Total Pool Balance'),
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            totalBalance,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: quickActions.map((a) => _buildQuickActionButton(a)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(DashboardQuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25), width: 1),
            ),
            child: Icon(action.icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            action.label,
            style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}
