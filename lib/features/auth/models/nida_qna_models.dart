/// Model representing a NIDA Security Question.
class NidaQuestion {
  final int id;
  final String questionEn;
  final String questionSw;
  final String placeholderEn;
  final String placeholderSw;

  const NidaQuestion({
    required this.id,
    required this.questionEn,
    required this.questionSw,
    required this.placeholderEn,
    required this.placeholderSw,
  });

  String getQuestion(bool isSwahili) => isSwahili ? questionSw : questionEn;
  String getPlaceholder(bool isSwahili) => isSwahili ? placeholderSw : placeholderEn;
}

/// Sample NIDA questions used for verification flow.
class NidaQuestionBank {
  static const List<NidaQuestion> defaultQuestions = [
    NidaQuestion(
      id: 1,
      questionEn: 'In which district was your primary school located?',
      questionSw: 'Shule yako ya msingi ilikuwa katika wilaya gani?',
      placeholderEn: 'e.g. Ilala, Kinondoni, Arusha',
      placeholderSw: 'mf. Ilala, Kinondoni, Arusha',
    ),
    NidaQuestion(
      id: 2,
      questionEn: 'What is your mother\'s maiden middle name?',
      questionSw: 'Jina la kati la mama yako mzazi kabla ya kuolewa ni lipi?',
      placeholderEn: 'Enter mother\'s middle name',
      placeholderSw: 'Weka jina la kati la mama',
    ),
    NidaQuestion(
      id: 3,
      questionEn: 'What is the name of your birth ward (kata)?',
      questionSw: 'Jina la kata uliyozaliwa ni lipi?',
      placeholderEn: 'e.g. Upanga, Kariakoo, Mwananyamala',
      placeholderSw: 'mf. Upanga, Kariakoo, Mwananyamala',
    ),
    NidaQuestion(
      id: 4,
      questionEn: 'In what year was your first voter\'s card registered?',
      questionSw: 'Kadi yako ya kwanza ya mpiga kura ilisajiliwa mwaka gani?',
      placeholderEn: 'e.g. 2015',
      placeholderSw: 'mf. 2015',
    ),
    NidaQuestion(
      id: 5,
      questionEn: 'Which region did your family originate from?',
      questionSw: 'Familia yako asili yake ni mkoa gani?',
      placeholderEn: 'e.g. Kilimanjaro, Mwanza, Mbeya',
      placeholderSw: 'mf. Kilimanjaro, Mwanza, Mbeya',
    ),
  ];
}
