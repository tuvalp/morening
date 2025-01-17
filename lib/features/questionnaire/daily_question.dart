import '/features/questionnaire/domain/question_type.dart';

import 'domain/models/option.dart';
import 'domain/models/question.dart';

List<Question> questions = [
  Question(
    header: "Help us to refinde your wake-up process",
    question: "Did you wake up in time?",
    options: [
      Option("Before Schulde", 0),
      Option("Right o time", 1),
      Option("After Schulde", 2),
    ],
  ),
  Question(
    question: "How did you feel this morning?",
    options: [
      Option("Vary tiaerd", 0),
      Option("as Usual", 1),
      Option("More refreshed", 2),
    ],
  ),
  Question(
    question: "Did one or more of the trigger was to strong for you?",
    type: QuestionType.multiSelect,
    options: [
      Option("light", 0),
      Option("sound", 1),
      Option("smell", 2),
    ],
  ),
];
