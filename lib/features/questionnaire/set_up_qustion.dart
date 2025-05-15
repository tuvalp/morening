import '/features/questionnaire/domain/question_type.dart';

import 'domain/models/option.dart';
import 'domain/models/question.dart';

List<Question> questions = [
  Question(
    header: "Let’s get to know you",
    question: "How old are you?",
    options: [
      Option("Under 18"),
      Option("18-29"),
      Option("30-39"),
      Option("40-49"),
      Option("50 and above"),
    ],
  ),
  Question(
    question: "What is your marital status?",
    options: [
      Option("Single"),
      Option("In a relationship"),
      Option("Married"),
      Option("Parent"),
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
      Option("Private house"),
      Option("Apartment building"),
      Option("House in a rural area"),
      Option("Other"),
    ],
  ),
  Question(
    question: "Are there environmental noises in your area in the morning?",
    options: [
      Option("Yes, traffic noise"),
      Option("Yes, natural noise (birds, wind, etc.)"),
      Option("Yes, industrial noise (construction, machinery, etc.)"),
      Option("No, the area is relatively quiet"),
    ],
  ),
  Question(
    header: "Sleep Habits",
    question: "How many hours of sleep do you get on average per night?",
    options: [
      Option("Less than 5"),
      Option("5-6"),
      Option("7-8"),
      Option("More than 8"),
    ],
  ),
  Question(
    question: "Do you have a diagnosed sleep disorder?",
    options: [
      Option("No"),
      Option("Insomnia"),
      Option("Sleep apnea"),
      Option("Restless sleep"),
      Option("Other"),
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
      Option("Complete darkness"),
      Option("Minimal light"),
      Option("Ambient light"),
    ],
  ),
  Question(
    header: "Good Morning",
    question:
        "How long does it take you to get out of bed after your alarm rings?",
    options: [
      Option("Less than 5 minutes"),
      Option("5-15 minutes"),
      Option("15-30 minutes"),
      Option("More than 30 minutes"),
    ],
  ),
  Question(
    question:
        "How many times do you press the snooze button in the morning on average?",
    options: [
      Option("Never"),
      Option("Once"),
      Option("Twice"),
      Option("Three or more times"),
    ],
  ),
  Question(
    question: "How do you feel in the mornings immediately after waking up?",
    options: [
      Option("Refreshed and energetic"),
      Option("Tired but ready to start the day"),
      Option("Very tired and struggle to start the day"),
      Option("Frustrated and drained"),
    ],
  ),
  Question(
    question: "How many alarm clocks do you use in the morning?",
    options: [
      Option("1"),
      Option("2-3"),
      Option("4-5"),
      Option("More than 5"),
    ],
  ),
  Question(
    question: "Do you tend to wake up in the middle of the night?",
    options: [
      Option("Rarely"),
      Option("Occasionally"),
      Option("Frequently"),
    ],
  ),
  Question(
    header: "Personal Preferences for Waking Up",
    question: "What type of sounds do you prefer to hear during wake-up?",
    options: [
      Option("Natural sounds (birds, flowing water, etc.)"),
      Option("Relaxing music"),
      Option("White noise"),
      Option("Ambient sounds (waves, wind, etc.)"),
    ],
  ),
  Question(
    question: "How much do you feel light helps you wake up?",
    options: [
      Option("Wakes me up instantly"),
      Option("Helps wake me up gradually"),
      Option("Does not affect my sleep"),
    ],
  ),
  Question(
    question: "How sensitive are you to smells?",
    options: [
      Option("Very sensitive"),
      Option("Normal"),
      Option("Not sensitive"),
    ],
  ),
];
