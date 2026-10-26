import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';
import '../utils/colors.dart';

enum ToastType {
  success,
  warning,
  danger,
  info;

  static const ToastType error = ToastType.danger;
}

/// A modern, premium toast notification positioned at [topCenter] with smooth slide & fade animation.
/// Completely replaces default SnackBars across the app.
class CustomToast {
  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String message,
    String? title,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Dismiss any existing toast first
    dismiss();

    final overlay = Overlay.of(context, rootOverlay: true);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _ToastWidget(
        title: title,
        message: message,
        type: type,
        duration: duration,
        onDismiss: () {
          if (_currentEntry == entry) {
            _currentEntry?.remove();
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final l10n = AppLocalizations.of(context);
    show(
      context,
      message: message,
      title: title ?? l10n?.success ?? 'Success',
      type: ToastType.success,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final l10n = AppLocalizations.of(context);
    show(
      context,
      message: message,
      title: title ?? l10n?.warning ?? 'Warning',
      type: ToastType.warning,
      duration: duration,
    );
  }

  static void showDanger(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final l10n = AppLocalizations.of(context);
    show(
      context,
      message: message,
      title: title ?? l10n?.error ?? 'Error',
      type: ToastType.danger,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) =>
      showDanger(context, message, title: title, duration: duration);

  static void showInfo(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final l10n = AppLocalizations.of(context);
    show(
      context,
      message: message,
      title: title ?? l10n?.info ?? 'Info',
      type: ToastType.info,
      duration: duration,
    );
  }

  static void dismiss() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _ToastWidget extends StatefulWidget {
  final String? title;
  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastWidget({
    this.title,
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    _dismissTimer = Timer(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (_controller.status != AnimationStatus.dismissed) {
      _controller.reverse().then((_) {
        if (mounted) {
          widget.onDismiss();
        }
      });
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _controller.dispose();
    super.dispose();
  }

  Color _getTypeColor() {
    switch (widget.type) {
      case ToastType.success:
        return const Color(0xFF22C55E); // Crisp green
      case ToastType.warning:
        return const Color(0xFFF59E0B); // Amber
      case ToastType.danger:
        return const Color(0xFFEF4444); // Red
      case ToastType.info:
        return AppColors.appPrimaryColor; // Teal brand
    }
  }

  IconData _getTypeIcon() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle_rounded;
      case ToastType.warning:
        return Icons.warning_amber_rounded;
      case ToastType.danger:
        return Icons.error_rounded;
      case ToastType.info:
        return Icons.info_rounded;
    }
  }

  String _getDefaultTitle(AppLocalizations? l10n, ToastType type) {
    switch (type) {
      case ToastType.success:
        return l10n?.success ?? 'Success';
      case ToastType.warning:
        return l10n?.warning ?? 'Warning';
      case ToastType.danger:
        return l10n?.error ?? 'Error';
      case ToastType.info:
        return l10n?.info ?? 'Info';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final typeColor = _getTypeColor();
    final effectiveTitle = widget.title ?? _getDefaultTitle(l10n, widget.type);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E232A) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: typeColor.withValues(alpha: 0.4),
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Type Icon Left
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTypeIcon(),
                      color: typeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Message / Title Right
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (effectiveTitle.isNotEmpty) ...[
                          Text(
                            effectiveTitle,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          widget.message,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : Colors.black87,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close button
                  GestureDetector(
                    onTap: _dismiss,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: isDark ? Colors.white38 : Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
