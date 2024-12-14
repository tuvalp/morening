import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/format.dart';
import '../../../plan/domain/models/plan.dart';
import '../../../plan/presention/components/plan_dialog.dart';
import '../../../plan/presention/plan_cubit.dart';
import '../../../plan/presention/plan_state.dart';

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
    return BlocBuilder<PlanCubit, PlanState>(
      builder: (context, state) {
        if (state is PlanLoading || state is PlanInitial) {
          // Load plans when sheet is opened and in initial state
          if (state is PlanInitial) {
            context.read<PlanCubit>().loadPlan();
          }
          return const Center(child: CircularProgressIndicator());
        } else if (state is PlanError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.message),
                ElevatedButton(
                  onPressed: () => context.read<PlanCubit>().loadPlan(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is PlanLoaded) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Wakeup Plan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(color: Theme.of(context).colorScheme.onSecondary),
                const SizedBox(height: 20),
                if (state.plans.isEmpty)
                  const Center(child: Text('No plans available'))
                else
                  for (Plan plan in state.plans)
                    ListTile(
                      leading: IconButton(
                        onPressed: () => _selectPlan(context, plan.label),
                        icon: Icon(
                          selectedPlan == plan.label
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: selectedPlan == plan.label
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.info,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
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
        }
        return const Center(child: CircularProgressIndicator());
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
          backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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
