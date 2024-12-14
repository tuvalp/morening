import '../models/plan.dart';

abstract class PlanRepo {
  Future<List<Plan>> getPlans(String userId);
  Future<String> addPlan(String userId, Plan plan);
  Future<void> updatePlan(String userId, String planId, Plan plan);
  Future<void> deletePlan(String userId, String planId);
}
