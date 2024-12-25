import 'domain/models/option.dart';
import 'domain/models/question.dart';

List<Question> questions = [
  Question(
    "בן כמה אתה?",
    [
      Option("מתחת ל18", 20),
      Option("19-29", 30),
      Option("30-39", 40),
      Option("40-49", 30),
      Option("מעל 50", 20),
    ],
  ),
  Question("כמה שעות שינה אתה ישן בלילה בממוצע?", [
    Option("פחות מ-5", 10),
    Option("5-6", 20),
    Option("7-8", 30),
    Option("יותר מ-8", 40),
  ]),
  Question("כמה זמן לוקח לך להתעורר בבוקר?", [
    Option("פחות מ-5 דקות", 40),
    Option("5-15 דקות", 30),
    Option("15-30 דקות", 20),
    Option("יותר מ-30 דקות", 10),
  ]),
  Question("איך אתה מרגיש בבוקר?", [
    Option("רענן ומלא אנרגיה", 40),
    Option("עייף אך מוכן לעבוד", 30),
    Option("עייף מאוד", 20),
    Option("עייף ומתוסכל", 10),
  ]),
];
