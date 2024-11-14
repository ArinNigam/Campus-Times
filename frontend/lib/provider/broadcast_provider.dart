import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constants.dart';
import '../models/broadcast_schema.dart';

final broadcastProvider =
    StateNotifierProvider<BroadcastStateNotifier, BroadcastState>(
  (ref) => BroadcastStateNotifier(ref),
);

class BroadcastState {
  final int selectedProgramIndex;
  final LoadingState loadingState;
  final Map<String, List<Broadcast>> categorizedBroadcasts;

  BroadcastState({
    required this.selectedProgramIndex,
    required this.loadingState,
    required this.categorizedBroadcasts,
  });

  BroadcastState copyWith({
    int? selectedProgramIndex,
    LoadingState? loadingState,
    Map<String, List<Broadcast>>? categorizedBroadcasts,
  }) {
    return BroadcastState(
      selectedProgramIndex: selectedProgramIndex ?? this.selectedProgramIndex,
      loadingState: loadingState ?? this.loadingState,
      categorizedBroadcasts:
          categorizedBroadcasts ?? this.categorizedBroadcasts,
    );
  }
}

class BroadcastStateNotifier extends StateNotifier<BroadcastState> {
  BroadcastStateNotifier(Ref ref)
      : super(BroadcastState(
          selectedProgramIndex: 0,
          loadingState: LoadingState.idle,
          categorizedBroadcasts:
              _categorizeBroadcasts(BroadcastConstants.sampleBroadcasts),
        ));

  void selectProgram(int index) {
    state = state.copyWith(selectedProgramIndex: index);
  }

  void setLoadingState(LoadingState loadingState) {
    state = state.copyWith(loadingState: loadingState);
  }

  static Map<String, List<Broadcast>> _categorizeBroadcasts(
      List<Broadcast> broadcasts) {
    final Map<String, List<Broadcast>> categorizedBroadcasts = {};
    for (var broadcast in broadcasts) {
      if (!categorizedBroadcasts.containsKey(broadcast.category)) {
        categorizedBroadcasts[broadcast.category] = [];
      }
      categorizedBroadcasts[broadcast.category]!.add(broadcast);
    }
    return categorizedBroadcasts;
  }
}
