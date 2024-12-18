import 'package:flutter/material.dart';

import 'features/auth/presention/components/auth_button.dart';

class QuestionnaireWidget extends StatefulWidget {
  @override
  _QuestionnaireWidgetState createState() => _QuestionnaireWidgetState();
}

class _QuestionnaireWidgetState extends State<QuestionnaireWidget> {
  final Map<String, dynamic> wakeUpQuestionnaire = {
    "intro":
        "היי, איזה כיף שבחרת ב-MOREning! הבוקר שלך הוא הדבר הכי חשוב לנו, ולכן נשמח להכיר אותך קצת יותר. השאלון הקצר הבא יעזור לנו להבין את ההרגלים וההעדפות שלך, כדי שנוכל להתאים לך תוכנית יקיצה מושלמת.",
    "sections": [
      {
        "title": "Let's get to know you",
        "questions": [
          {
            "question": "בן כמה אתה?",
            "type": "multipleChoice",
            "options": [
              {"label": "מתחת ל-18", "points": 20},
              {"label": "18-29", "points": 30},
              {"label": "30-39", "points": 40},
              {"label": "40-49", "points": 30},
              {"label": "50 ומעלה", "points": 20},
            ],
          },
          {
            "question": "מהו הסטטוס המשפחתי שלך?",
            "type": "multipleChoice",
            "options": [
              {"label": "רווק/ה", "points": 0},
              {"label": "בזוגיות", "points": 0},
              {"label": "נשוי/אה", "points": 0},
              {"label": "הורה", "points": 0},
            ],
          },
        ],
      },
      {
        "title": "Sleep Habits",
        "questions": [
          {
            "question": "כמה שעות שינה אתה מקבל בלילה בממוצע?",
            "type": "multipleChoice",
            "options": [
              {"label": "פחות מ-5", "points": 10},
              {"label": "5-6", "points": 20},
              {"label": "7-8", "points": 30},
              {"label": "יותר מ-8", "points": 40},
            ],
          },
        ],
      },
    ],
  };

  Map<String, dynamic> userAnswers = {};
  int currentQuestionIndex = 0;
  List<dynamic> allQuestions = [];

  @override
  void initState() {
    super.initState();
    _flattenQuestions();
  }

  void _flattenQuestions() {
    for (var section in wakeUpQuestionnaire['sections']) {
      allQuestions.addAll(section['questions']);
    }
  }

  void saveAnswer(String question, dynamic answer) {
    setState(() {
      userAnswers[question] = answer;
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < allQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = allQuestions[currentQuestionIndex];

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 62),
              _buildHeader(context),
              const SizedBox(height: 62),
              _buildQuestionCard(currentQuestion),
              const SizedBox(height: 32),
              _buildNavigationButtons(),
              const SizedBox(height: 62),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the header with the app name and welcome message.
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'MoreNing',
          style: TextStyle(
            fontSize: 54,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Text(
          'Your personalized wake-up experience',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Builds the question card with the current question.
  Widget _buildQuestionCard(dynamic question) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "שאלה ${currentQuestionIndex + 1} מתוך ${allQuestions.length}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            question['question'],
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          if (question['type'] == 'multipleChoice')
            Column(
              children: List.generate(
                question['options'].length,
                (optionIndex) {
                  final option = question['options'][optionIndex];
                  return RadioListTile(
                    title: Text(option['label']),
                    value: option['label'],
                    groupValue: userAnswers[question['question']],
                    onChanged: (value) {
                      saveAnswer(question['question'], value);
                    },
                  );
                },
              ),
            ),
          if (question['type'] == 'text')
            TextField(
              onChanged: (value) {
                saveAnswer(question['question'], value);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter your answer",
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the navigation buttons.
  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (currentQuestionIndex > 0)
          AuthButton(
            text: "Previous",
            onPressed: previousQuestion,
          ),
        ElevatedButton(
          onPressed: currentQuestionIndex == allQuestions.length - 1
              ? () {
                  print(userAnswers); // Save JSON or send to API
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("All answers saved!")),
                  );
                }
              : nextQuestion,
          child: Text(
            currentQuestionIndex == allQuestions.length - 1 ? "Finish" : "Next",
          ),
        ),
      ],
    );
  }
}
