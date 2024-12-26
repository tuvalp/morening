class Answer {
  final String question;
  final String answer;
  final int points;

  Answer({
    required this.question,
    required this.answer,
    required this.points,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      question: json['question'] ?? "",
      answer: json['answer'] ?? "",
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'points': points,
    };
  }
}
