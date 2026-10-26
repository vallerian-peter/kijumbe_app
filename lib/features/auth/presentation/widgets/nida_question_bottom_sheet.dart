import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../models/nida_qna_models.dart';

/// Modal bottom sheet showing NIDA security question(s) for identity verification.
class NidaQuestionBottomSheet extends StatefulWidget {
  final NidaQuestion question;
  final int questionNumber;
  final int totalQuestions;

  const NidaQuestionBottomSheet({
    super.key,
    required this.question,
    this.questionNumber = 1,
    this.totalQuestions = 1,
  });

  static Future<bool?> show(
    BuildContext context, {
    NidaQuestion? question,
    int questionNumber = 1,
    int totalQuestions = 1,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NidaQuestionBottomSheet(
        question: question ?? NidaQuestionBank.defaultQuestions.first,
        questionNumber: questionNumber,
        totalQuestions: totalQuestions,
      ),
    );
  }

  @override
  State<NidaQuestionBottomSheet> createState() => _NidaQuestionBottomSheetState();
}

class _NidaQuestionBottomSheetState extends State<NidaQuestionBottomSheet> {
  late final TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _submit() {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) {
      CustomToast.showWarning(
        context,
        context.l10n.nidaAnswerPrompt,
      );
      return;
    }

    // Dismiss sheet with success
    Navigator.of(context).pop(true);
  }

  void _skip() {
    // Dismiss sheet
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSwahili = Localizations.localeOf(context).languageCode == 'sw';

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Badge & Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${l10n.nidaQuestionBadge} #${widget.questionNumber}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Question Title (English / Main)
              Text(
                widget.question.getQuestion(isSwahili),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle in alternative language
              Text(
                widget.question.getQuestion(!isSwahili),
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Answer Input Field
              CustomTextField(
                label: l10n.nidaAnswerLabel,
                hintText: widget.question.getPlaceholder(isSwahili),
                controller: _answerController,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 22),

              // Action Buttons: Skip & Submit
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _skip,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        l10n.skipQuestion,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: l10n.submitAnswer,
                      height: 50,
                      borderRadius: 12,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
