import '../../domain/models/plan.dart';
import '../../domain/repository/plan_repo.dart';
import '../plan_mock.dart';

class PlanApiRepo implements PlanRepo {
  @override
  Future<List<Plan>> getPlan() async {
    if (plansMookup.isNotEmpty) {
      return plansMookup.map((plan) {
        return Plan.fromJson(plan.toJson());
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> setPlan(Plan plan) {
    // TODO: implement setPlan
    throw UnimplementedError();
  }

  @override
  Future<void> deletePlan() {
    // TODO: implement deletePlan
    throw UnimplementedError();
  }
}
