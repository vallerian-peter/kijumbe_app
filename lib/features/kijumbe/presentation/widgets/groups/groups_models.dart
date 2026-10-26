import 'package:flutter/material.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

enum GroupItemStatus { active, completed, pending }

String localizeFrequency(String frequency, AppLocalizations? l10n) {
  final lower = frequency.toLowerCase().trim();
  if (lower == 'weekly') return l10n?.weekly ?? 'Weekly';
  if (lower == 'monthly') return l10n?.monthly ?? 'Monthly';
  if (lower == 'bi-weekly' || lower == 'biweekly') {
    return l10n?.biWeekly ?? 'Bi-weekly';
  }
  if (lower == 'daily') return l10n?.daily ?? 'Daily';
  if (lower == 'cycle') return l10n?.cycle ?? 'Cycle';
  return frequency;
}

class GroupsListItem {
  final String name;
  final int memberCount;
  final int targetMembers;
  final String contribution;
  final String frequency;
  final int paidCount;
  final int totalSlots;
  final String nextContribution;
  final String totalPot;
  final GroupItemStatus status;
  final List<Color> avatarColors;
  final int currentRound;
  final String kijumbeName;

  const GroupsListItem({
    required this.name,
    required this.memberCount,
    required this.targetMembers,
    required this.contribution,
    required this.frequency,
    required this.paidCount,
    required this.totalSlots,
    required this.nextContribution,
    required this.totalPot,
    required this.status,
    required this.avatarColors,
    required this.currentRound,
    required this.kijumbeName,
  });
}
