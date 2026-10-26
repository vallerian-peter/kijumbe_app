import 'package:flutter/material.dart';

class DashboardQuickAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DashboardQuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class DashboardGroupSummary {
  final String name;
  final int memberCount;
  final int targetMembers;
  final String contributionAmount;
  final String frequency;
  final int paidCount;
  final int totalSlots;
  final String nextPayout;
  final String totalPot;
  final List<Color> avatarColors;

  const DashboardGroupSummary({
    required this.name,
    required this.memberCount,
    required this.targetMembers,
    required this.contributionAmount,
    required this.frequency,
    required this.paidCount,
    required this.totalSlots,
    required this.nextPayout,
    required this.totalPot,
    required this.avatarColors,
  });
}

enum DashboardActivityType { sent, received, group }

class DashboardActivityItem {
  final String name;
  final String subtitle;
  final String date;
  final String amount;
  final bool isCredit;
  final DashboardActivityType type;

  const DashboardActivityItem({
    required this.name,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.type,
  });
}

class DashboardStatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const DashboardStatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });
}
