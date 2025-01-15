import 'package:morening_2/features/questionnaire/domain/question_type.dart';

import 'domain/models/option.dart';
import 'domain/models/question.dart';

List<Question> questions = [
  Question(
    header: "Let’s get to know you",
    question: "How old are you?",
    options: [
      Option("Under 18", 0),
      Option("18-29", 1),
      Option("30-39", 2),
      Option("40-49", 3),
      Option("50 and above", 4),
    ],
  ),
  Question(
    question: "What is your marital status?",
    options: [
      Option("Single", 0),
      Option("In a relationship", 1),
      Option("Married", 2),
      Option("Parent", 3),
    ],
  ),
  Question(
    header: "No Place Like Home",
    question: "Where do you live? (City/Town)",
    type: QuestionType.freeText,
    options: [],
  ),
  Question(
    question: "What type of residence do you live in?",
    options: [
      Option("Private house", 0),
      Option("Apartment building", 1),
      Option("House in a rural area", 2),
      Option("Other", 3),
    ],
  ),
  Question(
    question: "Are there environmental noises in your area in the morning?",
    options: [
      Option("Yes, traffic noise", 0),
      Option("Yes, natural noise (birds, wind, etc.)", 1),
      Option("Yes, industrial noise (construction, machinery, etc.)", 2),
      Option("No, the area is relatively quiet", 3),
    ],
  ),
  Question(
    header: "Sleep Habits",
    question: "How many hours of sleep do you get on average per night?",
    options: [
      Option("Less than 5", 0),
      Option("5-6", 1),
      Option("7-8", 2),
      Option("More than 8", 3),
    ],
  ),
  Question(
    question: "Do you have a diagnosed sleep disorder?",
    options: [
      Option("No", 0),
      Option("Insomnia", 1),
      Option("Sleep apnea", 2),
      Option("Restless sleep", 3),
      Option("Other", 4),
    ],
  ),
  Question(
    question: "Rate the quality of your sleep on a scale of 1-10:",
    type: QuestionType.freeText,
    options: [],
  ),
  Question(
    question: "Do you sleep with blackout curtains or minimal light?",
    options: [
      Option("Complete darkness", 0),
      Option("Minimal light", 1),
      Option("Ambient light", 2),
    ],
  ),
  Question(
    header: "Good Morning",
    question:
        "How long does it take you to get out of bed after your alarm rings?",
    options: [
      Option("Less than 5 minutes", 0),
      Option("5-15 minutes", 1),
      Option("15-30 minutes", 2),
      Option("More than 30 minutes", 3),
    ],
  ),
  Question(
    question:
        "How many times do you press the snooze button in the morning on average?",
    options: [
      Option("Never", 0),
      Option("Once", 1),
      Option("Twice", 2),
      Option("Three or more times", 3),
    ],
  ),
  Question(
    question: "How do you feel in the mornings immediately after waking up?",
    options: [
      Option("Refreshed and energetic", 0),
      Option("Tired but ready to start the day", 1),
      Option("Very tired and struggle to start the day", 2),
      Option("Frustrated and drained", 3),
    ],
  ),
  Question(
    question: "How many alarm clocks do you use in the morning?",
    options: [
      Option("1", 0),
      Option("2-3", 1),
      Option("4-5", 2),
      Option("More than 5", 3),
    ],
  ),
  Question(
    question: "Do you tend to wake up in the middle of the night?",
    options: [
      Option("Rarely", 0),
      Option("Occasionally", 1),
      Option("Frequently", 2),
    ],
  ),
  Question(
    header: "Personal Preferences for Waking Up",
    question: "What type of sounds do you prefer to hear during wake-up?",
    options: [
      Option("Natural sounds (birds, flowing water, etc.)", 0),
      Option("Relaxing music", 1),
      Option("White noise", 2),
      Option("Ambient sounds (waves, wind, etc.)", 3),
    ],
  ),
  Question(
    question: "How much do you feel light helps you wake up?",
    options: [
      Option("Wakes me up instantly", 0),
      Option("Helps wake me up gradually", 1),
      Option("Does not affect my sleep", 2),
    ],
  ),
  Question(
    question: "How sensitive are you to smells?",
    options: [
      Option("Very sensitive", 0),
      Option("Normal", 1),
      Option("Not sensitive", 2),
    ],
  ),
];
