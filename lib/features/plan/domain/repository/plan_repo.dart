import '../models/plan.dart';

abstract class PlanRepo {
  Future<List<Plan>> getPlan();
  Future<void> setPlan(Plan plan);
  Future<void> deletePlan();
}
