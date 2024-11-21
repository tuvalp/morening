import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/models/plan.dart';
import '../domain/repository/plan_repo.dart';

class PlanCubit extends Cubit<List<Plan>> {
  final PlanRepo planRepo;

  PlanCubit(this.planRepo) : super([]) {
    loadPlan();
  }

  Future<void> loadPlan() async {
    final plans = await planRepo.getPlan();
    emit(plans);
  }
}
