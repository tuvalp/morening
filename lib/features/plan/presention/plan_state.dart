import '../domain/models/plan.dart';

abstract class PlanState {}

class PlanInitial extends PlanState {
  final String userId;

  PlanInitial(this.userId);
}

class PlanLoading extends PlanState {
  final String userId;

  PlanLoading(this.userId);
}

class PlanLoaded extends PlanState {
  final List<Plan> plans;
  PlanLoaded(this.plans);
}

class PlanError extends PlanState {
  final String message;

  PlanError(this.message);
}
