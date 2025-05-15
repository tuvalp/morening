import '../question_type.dart';
import 'option.dart';

class Question {
  final String? header;
  final QuestionType type;
  final String question;
  final List<Option> options;

  Question({
    this.header,
    this.type = QuestionType.singleSelect,
    required this.question,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    QuestionType questionType;

    if (json['type'] is int) {
      questionType = QuestionType.values[json['type']];
    } else if (json['type'] is String) {
      // Parse string type to enum
      questionType = QuestionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => QuestionType.singleSelect,
      );
    } else {
      questionType = QuestionType.singleSelect;
    }

    return Question(
      header: json['header'],
      type: questionType,
      question: json['question'] ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
