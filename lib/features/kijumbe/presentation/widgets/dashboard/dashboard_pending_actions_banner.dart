import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';

class DashboardPendingActionsBanner extends StatelessWidget {
  final int pendingActions;
  final VoidCallback? onTap;

  const DashboardPendingActionsBanner({
    super.key,
    required this.pendingActions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PendingContributionsCard(
      pendingCount: pendingActions,
      onTap: onTap,
    );
  }
}
