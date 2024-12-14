import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repository/plan_repo.dart';
import 'plan_state.dart';

class PlanCubit extends Cubit<PlanState> {
  final PlanRepo planRepo;
  String userId;

  PlanCubit(this.planRepo, this.userId) : super(PlanInitial(userId));

  Future<void> loadPlan() async {
    print('loadPlan started');
    emit(PlanLoading(userId));
    try {
      final plans = await planRepo.getPlans(userId);
      print('Plans received: $plans');
      emit(PlanLoaded(plans));
    } catch (e, stackTrace) {
      print('Error loading plans: $e');
      print('Stack trace: $stackTrace');
      emit(PlanError(e.toString()));
    }
  }
}
