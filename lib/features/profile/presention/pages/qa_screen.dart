import 'package:flutter/material.dart';

class QaScreen extends StatefulWidget {
  const QaScreen({super.key});

  @override
  State<QaScreen> createState() => _QaScreenState();
}

class _QaScreenState extends State<QaScreen> with TickerProviderStateMixin {
  int selectedIndex = 0;

  void openRow(int index) {
    setState(() {
      if (index == selectedIndex) {
        selectedIndex = 0;
      } else {
        selectedIndex = index;
      }
    });
  }

  final List<Map> qaList = [
    {
      "index": 1,
      "q": "First question",
      "a":
          "Answer one: A detailed answer goes here. It can be as long as needed.",
    },
    {
      "index": 2,
      "q": "Second question",
      "a": "Answer two: A short response.",
    },
    {
      "index": 3,
      "q": "Third question",
      "a": "Answer three: Another brief answer.",
    },
    {
      "index": 4,
      "q": "Fourth question",
      "a": "Answer four: This is a detailed explanation for the question.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Q&A"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ListView(
          children: [for (Map obj in qaList) _buildRow(context, obj)],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, Map obj) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  obj["q"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => openRow(obj["index"]),
                icon: obj["index"] != selectedIndex
                    ? const Icon(Icons.arrow_drop_down_rounded)
                    : const Icon(Icons.arrow_drop_up_rounded),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: obj["index"] == selectedIndex
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      obj["a"],
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
