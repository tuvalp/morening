import '../question_type.dart';

class Question {
  final String? header;
  final QuestionType type;
  final String question;
  final List<dynamic> options;

  Question({
    this.header,
    this.type = QuestionType.singleSelect,
    required this.question,
    required this.options,
  });
}
