part of 'metronome_cubit.dart';

enum MetronomeStatus {
  playing,
  paused,
}

class MetronomeState extends Equatable {
  const MetronomeState({
    this.status = MetronomeStatus.paused,
    required this.initialBpm,
    required this.currentBpm,
    required this.currentBar,
    required this.currentSubdivision,
  });
  final MetronomeStatus status;
  final int? initialBpm;
  final int currentBpm;
  final Bar currentBar;
  final NoteValue currentSubdivision;

  @override
  List<Object?> get props => [
        status,
        initialBpm,
        currentBpm,
        currentBar,
        currentSubdivision,
      ];

  MetronomeState copyWith({
    MetronomeStatus? status,
    int? initialBpm,
    int? currentBpm,
    Bar? currentBar,
    NoteValue? currentSubdivision,
  }) {
    return MetronomeState(
      status: status ?? this.status,
      initialBpm: initialBpm ?? this.initialBpm,
      currentBpm: currentBpm ?? this.currentBpm,
      currentBar: currentBar ?? this.currentBar,
      currentSubdivision: currentSubdivision ?? this.currentSubdivision,
    );
  }
}
