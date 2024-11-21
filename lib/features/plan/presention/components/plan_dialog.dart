import 'package:flutter/material.dart';

import '../../../../utils/format.dart';
import '../../domain/models/plan.dart';

class PlanDialog extends StatelessWidget {
  final Plan plan;
  final int itemsPerRow = 2;

  const PlanDialog({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Format.formatPlanLabel(plan.label),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text("${plan.startDeltaBeforeAwake} minutes before awake"),
            const SizedBox(height: 10),
            SizedBox(
              child: Column(
                children: List.generate(
                  (plan.stages.length / itemsPerRow).ceil(),
                  (rowIndex) {
                    final int start = rowIndex * itemsPerRow;
                    final int end = (start + itemsPerRow < plan.stages.length)
                        ? start + itemsPerRow
                        : plan.stages.length;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(end - start, (index) {
                          final stage = plan.stages[start + index];
                          var nextStage;
                          if (start + index + 1 < plan.stages.length) {
                            nextStage = plan.stages[start + index + 1];
                          }
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(Format.formatDuration(stage.duration)),
                              Icon(
                                Format.getTriggerIcon(stage.trigger),
                                color: Colors.blue,
                                size: 24,
                              ),
                              const SizedBox(width: 5),
                              if (start + index < plan.stages.length - 1)
                                const Icon(Icons.arrow_forward, size: 16),
                              const SizedBox(width: 5),
                              if (nextStage != null)
                                Text("${nextStage.deltaTime}m"),
                              if (nextStage != null) const SizedBox(width: 5),
                              if (nextStage != null)
                                const Icon(Icons.arrow_forward, size: 16),
                              if (nextStage != null) const SizedBox(width: 5),
                            ],
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            GestureDetector(
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
