import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/activity_model.dart';

class LogbookState {
  final List<Activity> activities;
  final Set<int> completed;

  LogbookState({
    required this.activities,
    required this.completed,
  });

  LogbookState copyWith({
    List<Activity>? activities,
    Set<int>? completed,
  }) {
    return LogbookState(
      activities: activities ?? this.activities,
      completed: completed ?? this.completed,
    );
  }
}

class LogbookController extends StateNotifier<LogbookState> {
  LogbookController() : super(LogbookState(activities: [], completed: {}));

  void setActivities(List<Activity> acts) {
    state = state.copyWith(activities: acts, completed: {});
  }

  void toggle(int index) {
    final newSet = Set<int>.from(state.completed);

    if (newSet.contains(index)) {
      newSet.remove(index);
    } else {
      newSet.add(index);
    }

    state = state.copyWith(completed: newSet);
  }

  bool isChecked(int index) {
    return state.completed.contains(index);
  }
}

final logbookProvider = StateNotifierProvider<LogbookController, LogbookState>(
  (ref) => LogbookController(),
);
