class Answer {
  final String answer;
  final int points;
  final String question;

  Answer({
    required this.answer,
    required this.points,
    required this.question,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answer: json['answer'] ?? "",
      points: json['points'] ?? 0,
      question: json['question'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'points': points,
      'question': question,
    };
  }
}
