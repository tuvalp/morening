class Answer {
  final String question;
  final String answer;
  final int points;

  Answer(this.question, this.answer, this.points);

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'points': points,
    };
  }
}
