import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/format.dart';
import '../../../plan/domain/models/plan.dart';
import '../../../plan/presention/components/plan_dialog.dart';
import '../../../plan/presention/plan_cubit.dart';

class PlansSheet extends StatelessWidget {
  final String selectedPlan;
  final void Function(String) onPlanChanged;

  const PlansSheet({
    super.key,
    required this.selectedPlan,
    required this.onPlanChanged,
  });

  void _selectPlan(BuildContext context, String plan) {
    onPlanChanged(plan);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanCubit, List<Plan>>(
      builder: (context, plans) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Wakeup Plan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 10),
              for (Plan plan in plans)
                ListTile(
                  leading: IconButton(
                    onPressed: () => _selectPlan(context, plan.label),
                    icon: Icon(
                      selectedPlan == plan.label
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: selectedPlan == plan.label
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => PlanDialog(plan: plan),
                      );
                    },
                  ),
                  title: GestureDetector(
                    onTap: () => _selectPlan(context, plan.label),
                    child: Text(Format.formatPlanLabel(plan.label)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class PlansPicker extends StatelessWidget {
  final String planId;
  final void Function(String) onPlanChanged;

  const PlansPicker({
    super.key,
    required this.planId,
    required this.onPlanChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => PlansSheet(
            selectedPlan: planId,
            onPlanChanged: onPlanChanged,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        );
      },
      child: Text(
        Format.formatPlanLabel(planId.isEmpty ? "Plan" : planId),
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
