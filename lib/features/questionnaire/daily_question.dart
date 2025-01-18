import '/features/questionnaire/domain/question_type.dart';

import 'domain/models/option.dart';
import 'domain/models/question.dart';

List<Question> questions = [
  Question(
    header: "Help us refine your wake-up process",
    question: "Did you wake up on time?",
    options: [
      Option("Before Schedule"),
      Option("Right on Time"),
      Option("After Schedule"),
    ],
  ),
  Question(
    question: "How did you feel this morning?",
    options: [
      Option("Very Tired"),
      Option("As Usual"),
      Option("More Refreshed"),
    ],
  ),
  Question(
    question: "Were any of the triggers too strong for you?",
    type: QuestionType.multiSelect,
    options: [
      Option("Light"),
      Option("Sound"),
      Option("Smell"),
    ],
  ),
];
