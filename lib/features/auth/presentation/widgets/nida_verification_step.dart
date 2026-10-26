import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../../helpers/helpers.dart';
import '../../models/nida_qna_models.dart';
import 'nida_question_bottom_sheet.dart';

class NidaVerificationStep extends StatefulWidget {
  final String initialNin;
  final bool initialVerified;
  final ValueChanged<String> onNinChanged;
  final void Function(bool isVerified) onVerificationStatusChanged;

  const NidaVerificationStep({
    super.key,
    required this.initialNin,
    required this.initialVerified,
    required this.onNinChanged,
    required this.onVerificationStatusChanged,
  });

  @override
  State<NidaVerificationStep> createState() => _NidaVerificationStepState();
}

class _NidaVerificationStepState extends State<NidaVerificationStep> {
  late TextEditingController _ninController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    // Format if initialNin is provided
    final rawDigits = widget.initialNin.replaceAll(RegExp(r'\D'), '');
    String initialText = rawDigits;
    if (rawDigits.length == 20) {
      initialText =
          '${rawDigits.substring(0, 8)}-${rawDigits.substring(8, 13)}-${rawDigits.substring(13, 18)}-${rawDigits.substring(18, 20)}';
    }
    _ninController = TextEditingController(text: initialText);
    _isCompleted = widget.initialVerified;
  }

  @override
  void dispose() {
    _ninController.dispose();
    super.dispose();
  }

  void _openQuestionBottomSheet() async {
    final rawDigits = NidaInputFormatter.unformat(_ninController.text);
    if (rawDigits.length != 20) {
      CustomToast.showWarning(
        context,
        context.l10n.enterFullNinFirst,
      );
      return;
    }

    // Launch QA in bottom sheet
    final success = await NidaQuestionBottomSheet.show(
      context,
      question: NidaQuestionBank.defaultQuestions.first,
      questionNumber: 1,
      totalQuestions: 1,
    );

    if (success == true && mounted) {
      setState(() {
        _isCompleted = true;
      });
      widget.onVerificationStatusChanged(true);
      CustomToast.showSuccess(
        context,
        context.l10n.nidaVerifiedSuccess,
      );
    }
  }

  void _restartVerification() {
    setState(() {
      _isCompleted = false;
    });
    widget.onVerificationStatusChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;
    final rawDigits = NidaInputFormatter.unformat(_ninController.text);
    final isNinComplete = rawDigits.length == 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Description
        Text(
          l10n.nidaVerificationTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.nidaSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? Colors.white70 : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 20),

        // NIN Text Field with strict hyphen formatting (20011229-16001-00001-23)
        CustomTextField(
          label: l10n.nidaNumberLabel,
          hintText: '20011229-16001-00001-23',
          controller: _ninController,
          keyboardType: TextInputType.number,
          inputFormatters: [NidaInputFormatter()],
          enabled: !_isCompleted,
          prefixIcon: const Icon(Icons.badge_outlined, size: 20),
          onChanged: (val) {
            final unformatted = NidaInputFormatter.unformat(val);
            widget.onNinChanged(unformatted);
            setState(() {});
          },
        ),
        const SizedBox(height: 16),

        // Notice Box
        CustomAlertBox(
          type: AlertType.info,
          title: l10n.nidaSecurityNoticeTitle,
          message: l10n.nidaSecurityNotice,
        ),
        const SizedBox(height: 20),

        // Status or Action trigger
        if (_isCompleted) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green, width: 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.nidaStatusVerified,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'NIN: ${_ninController.text}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _restartVerification,
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                size: 16,
                                color: isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                l10n.reVerify,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          CustomButton(
            text: l10n.nidaVerifyButton,
            onPressed: isNinComplete ? _openQuestionBottomSheet : null,
          ),
        ],
      ],
    );
  }
}
