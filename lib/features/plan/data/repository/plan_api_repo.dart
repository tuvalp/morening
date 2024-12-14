import 'dart:convert';
import '../../../../config/api_service.dart';
import '../../domain/models/plan.dart';
import '../../domain/repository/plan_repo.dart';

class PlanApiRepo implements PlanRepo {
  @override
  Future<List<Plan>> getPlans(String userId) async {
    try {
      print('Fetching plans for userId: $userId');
      final response = await ApiService.post('/getWakeUpPlans', {
        'user_id': userId,
      });

      if (response.statusCode != 200) {
        throw Exception('API error: ${response.statusCode} - ${response.body}');
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      final Map<String, dynamic> plans = data['plans'];

      return plans.entries
          .map((entry) {
            try {
              final List<dynamic> rawStages = entry.value['stages'] ?? [];
              final stages = rawStages.map((stage) {
                return {
                  'delta_time': stage['delta_time'] ?? 0,
                  'trigger': stage['trigger'] ?? '',
                  'options': {
                    'duration': stage['options']['duration'] ?? 0,
                    'volume': (stage['options']['volume'] ?? 0).toDouble(),
                    'song_path': stage['options']['song_path'] ?? '',
                  },
                };
              }).toList();

              final planJson = {
                'id': entry.key,
                'label': entry.value['name'] ?? '',
                'stages': stages,
                'start_delta_before_awake':
                    entry.value['start_delta_before_awake'] ?? 0,
              };

              print('Attempting to parse plan with data: $planJson');
              return Plan.fromJson(planJson);
            } catch (e, stack) {
              print('Error parsing individual plan: $e');
              print('Plan data that caused error: ${entry.value}');
              print('Stack trace: $stack');
              return null;
            }
          })
          .where((plan) => plan != null)
          .cast<Plan>()
          .toList();
    } catch (e, stackTrace) {
      print('Error in getPlans: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to get plans: $e');
    }
  }

  @override
  Future<String> addPlan(String userId, Plan plan) async {
    try {
      final response = await ApiService.post('/addWakeUpPlan', {
        'user_id': userId,
        'definition': plan.toJson(),
      });
      return jsonDecode(response.body)['wake_up_plan_id'];
    } catch (e) {
      throw Exception('Failed to add plan');
    }
  }

  @override
  Future<void> updatePlan(String userId, String planId, Plan plan) async {
    try {
      final response = await ApiService.post('/updateWakeUpPlan', {
        'user_id': userId,
        'wake_up_plan_id': planId,
        'definition': plan.toJson(),
      });
      return jsonDecode(response.body)['success'];
    } catch (e) {
      throw Exception('Failed to update plan');
    }
  }

  @override
  Future<void> deletePlan(String userId, String planId) async {
    try {
      final response = await ApiService.post('/deleteWakeUpPlan', {
        'user_id': userId,
        'wake_up_plan_id': planId,
      });
      return jsonDecode(response.body)['success'];
    } catch (e) {
      throw Exception('Failed to delete plan');
    }
  }
}
