class Answer {
  final String question;
  final String answer;

  Answer(this.question, this.answer);

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}
