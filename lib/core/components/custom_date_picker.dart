import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../localization/app_locale.dart';
import '../utils/colors.dart';

/// Calculation helpers for age validation.
class DateValidationUtils {
  static int calculateAge(DateTime birthDate, {DateTime? referenceDate}) {
    final now = referenceDate ?? DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  static bool is18OrOlder(DateTime birthDate, {DateTime? referenceDate}) {
    return calculateAge(birthDate, referenceDate: referenceDate) >= 18;
  }
}

enum DatePickerViewMode {
  wheel,
  calendar,
}

/// Unified, themed Date Picker Bottom Sheet for Kijumbe.
/// Supports BOTH the slidable Cupertino Wheel (with 10%+ increased height)
/// and the Material Calendar view, with toggle between both.
Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? minDate,
  DateTime? maxDate,
  String? title,
  String? confirmText,
  String? cancelText,
  bool require18Plus = false,
  DatePickerViewMode initialMode = DatePickerViewMode.wheel,
}) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final effectivePrimary = isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor;
  final effectiveMax = maxDate ??
      (require18Plus
          ? DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day)
          : DateTime.now());
  final effectiveMin = minDate ?? DateTime(1920, 1, 1);

  DateTime selected = initialDate ?? effectiveMax;
  if (selected.isAfter(effectiveMax)) selected = effectiveMax;
  if (selected.isBefore(effectiveMin)) selected = effectiveMin;

  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext ctx) {
      DateTime tempPicked = selected;
      DatePickerViewMode viewMode = initialMode;

      return StatefulBuilder(
        builder: (context, setModalState) {
          final age = DateValidationUtils.calculateAge(tempPicked);
          final isUnderAge = require18Plus && age < 18;

          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E232A) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  const SizedBox(height: 12),
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header with Title & Action buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(null),
                          style: TextButton.styleFrom(
                            foregroundColor: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          child: Text(
                            cancelText ?? context.l10n.commonCancel,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),

                        // Mode switcher toggle (Wheel vs Calendar)
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.black26 : Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildModeButton(
                                icon: Icons.view_carousel_rounded,
                                isSelected: viewMode == DatePickerViewMode.wheel,
                                isDark: isDark,
                                onTap: () => setModalState(() => viewMode = DatePickerViewMode.wheel),
                              ),
                              _buildModeButton(
                                icon: Icons.calendar_month_rounded,
                                isSelected: viewMode == DatePickerViewMode.calendar,
                                isDark: isDark,
                                onTap: () => setModalState(() => viewMode = DatePickerViewMode.calendar),
                              ),
                            ],
                          ),
                        ),

                        TextButton(
                          onPressed: isUnderAge
                              ? null
                              : () => Navigator.of(ctx).pop(tempPicked),
                          style: TextButton.styleFrom(
                            foregroundColor: effectivePrimary,
                            disabledForegroundColor: Colors.grey,
                          ),
                          child: Text(
                            confirmText ?? context.l10n.done,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Compact Header: "Sat, 26 Dec 2000" <---> "25 yrs old"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 17,
                              color: effectivePrimary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('EEE, d MMM yyyy').format(tempPicked),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : effectivePrimary,
                              ),
                            ),
                          ],
                        ),
                        if (require18Plus)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: isUnderAge
                                  ? Colors.red.withValues(alpha: 0.15)
                                  : effectivePrimary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$age ${context.l10n.yearsOld}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isUnderAge ? Colors.red : effectivePrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  if (isUnderAge)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          context.l10n.underAgeNotice,
                          style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                  // Content view: either Slidable Wheel (height increased +12%) OR Calendar Grid
                  if (viewMode == DatePickerViewMode.wheel)
                    SizedBox(
                      height: 242, // Increased height (+12%) for smoother scrolling
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          brightness: isDark ? Brightness.dark : Brightness.light,
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: tempPicked,
                          minimumDate: effectiveMin,
                          maximumDate: effectiveMax,
                          onDateTimeChanged: (DateTime newDate) {
                            setModalState(() {
                              tempPicked = newDate;
                            });
                          },
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 280,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                                primary: effectivePrimary,
                                onPrimary: Colors.white,
                              ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: tempPicked,
                          firstDate: effectiveMin,
                          lastDate: effectiveMax,
                          onDateChanged: (DateTime newDate) {
                            setModalState(() {
                              tempPicked = newDate;
                            });
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildModeButton({
  required IconData icon,
  required bool isSelected,
  required bool isDark,
  required VoidCallback onTap,
}) {
  final effectivePrimary = isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected
            ? effectivePrimary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 18,
        color: isSelected
            ? Colors.white
            : (isDark ? Colors.white54 : Colors.grey[600]),
      ),
    ),
  );
}

/// A dedicated, styled input field widget that launches [showCustomDatePicker].
/// Adheres strictly to Kijumbe theme and field layout.
class CustomDatePickerField extends StatelessWidget {
  final String label;
  final String? hintText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool require18Plus;
  final String? helperText;
  final String? errorText;
  final DateTime? minDate;
  final DateTime? maxDate;

  const CustomDatePickerField({
    super.key,
    required this.label,
    this.hintText,
    required this.selectedDate,
    required this.onDateSelected,
    this.require18Plus = true,
    this.helperText,
    this.errorText,
    this.minDate,
    this.maxDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectivePrimary = isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor;

    final hasDate = selectedDate != null;
    final formattedDate = hasDate ? DateFormat('EEE, d MMM yyyy').format(selectedDate!) : '';

    final isUnder18 = hasDate &&
        require18Plus &&
        !DateValidationUtils.is18OrOlder(selectedDate!);

    final effectiveError = errorText ?? (isUnder18 ? context.l10n.underAgeNotice : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleSmall?.color,
          ),
        ),
        const SizedBox(height: 8),

        // Interactive Field Container
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            final picked = await showCustomDatePicker(
              context: context,
              initialDate: selectedDate,
              minDate: minDate,
              maxDate: maxDate,
              require18Plus: require18Plus,
              title: label,
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E232A) : AppColors.appGreyWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: effectiveError != null
                    ? Colors.red
                    : (isDark ? Colors.white24 : Colors.black12),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasDate ? formattedDate : (hintText ?? context.l10n.dateOfBirthHint),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: hasDate ? FontWeight.w600 : FontWeight.w400,
                      color: hasDate
                          ? (isDark ? Colors.white : Colors.black87)
                          : (isDark ? Colors.white38 : Colors.grey[500]),
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  size: 20,
                  color: effectiveError != null
                      ? Colors.red
                      : effectivePrimary,
                ),
              ],
            ),
          ),
        ),

        // Helper / Error text
        if (effectiveError != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              effectiveError,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              helperText!,
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}
