import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_metronome/src/data/models/bar.dart';
import 'package:flutter_metronome/src/data/repositories/metronome_repository.dart';
import 'package:flutter_metronome/src/utils/metronome_config.dart';

part 'metronome_state.dart';

class MetronomeCubit extends Cubit<MetronomeState> {
  final int initialBpm;
  final int minBpm;
  final int maxBpm;
  final Bar initialBar;
  final NoteValue initialSubdivision;
  final MetronomeRepository metronomeRepository;

  MetronomeCubit({
    required this.metronomeRepository,
    required this.initialBar,
    required this.initialBpm,
    this.initialSubdivision = NoteValue.quarter,
    this.minBpm = MetronomeConfig.MIN_BPM,
    this.maxBpm = MetronomeConfig.MAX_BPM,
  }) : super(
          MetronomeState(
            initialBpm: initialBpm,
            currentBpm: initialBpm,
            currentBar: initialBar,
            currentSubdivision: initialSubdivision,
          ),
        ) {
    metronomeRepository.initializeMetronome();
  }

  Timer? _timer;

  /// Increases the currentBpm by a given amount (default=1)
  /// Stops metronome before doing so.
  /// emits [MetronomeStatus.paused] and returns maxBpm if it cant be increased
  /// emits [MetronomeStatus.paused] and returns currentBpm+amount
  /// if it can be increased
  void increaseBpm({int step = 1}) {
    _stopMetronome();

    final updatedBpm = state.currentBpm + step;

    if (updatedBpm > maxBpm) {
      emit(
        state.copyWith(
          status: MetronomeStatus.paused,
          currentBpm: maxBpm,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: MetronomeStatus.paused,
          currentBpm: updatedBpm,
        ),
      );
    }
  }

  /// Decreases the currentBpm by a given amount (default=1)
  /// Stops metronome before doing so.
  /// emits [MetronomeStatus.paused] and returns minBpm if it cant be increased
  /// emits [MetronomeStatus.paused] and returns currentBpm-amount
  /// if it can be increased
  void decreaseBpm({int step = 1}) {
    _stopMetronome();

    final updatedBpm = state.currentBpm - step;

    if (state.currentBpm >= step && updatedBpm >= minBpm) {
      emit(
        state.copyWith(
          status: MetronomeStatus.paused,
          currentBpm: updatedBpm,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: MetronomeStatus.paused,
          currentBpm: minBpm,
        ),
      );
    }
  }

  /// Sets a specific value to the metronome
  /// If value is greater than maxBpm, it will be set to maxBpm
  /// If value is less than minBpm, it will be set to minBpm
  /// emits [MetronomeStatus.paused] and returns value
  void setBpm(int newBpm) {
    _stopMetronome();

    if (newBpm >= maxBpm) {
      emit(
        state.copyWith(
          status: MetronomeStatus.paused,
          currentBpm: maxBpm,
        ),
      );
    } else if (newBpm <= minBpm) {
      emit(
        state.copyWith(
          status: MetronomeStatus.paused,
          currentBpm: minBpm,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: MetronomeStatus.paused,
          currentBpm: newBpm,
        ),
      );
    }
  }

  /// Changes the current bar and pauses the metronome
  /// emits [MetronomeStatus.paused]
  void changeBar(Bar newBar) {
    _stopMetronome();

    emit(state.copyWith(status: MetronomeStatus.paused, currentBar: newBar));
  }

  /// Changes the current subdivision and pauses the metronome
  /// emits [MetronomeStatus.paused]
  void changeSubdivision(NoteValue newValue) {
    _stopMetronome();

    emit(
      state.copyWith(
        status: MetronomeStatus.paused,
        currentSubdivision: newValue,
      ),
    );
  }

  /// Starts the metronome if bpm is not 0
  /// e.g. 120 bpm = 60/120 = tick every 0.5 seconds = 0.5 * 1000 = 500 ms
  /// e.g. 60 bpm = 60/60 = tick every 1 second = 1 * 1000 = 1000 ms
  /// emits [MetronomeStatus.paused] if metronome is already running
  /// also stops the metronome
  /// emits [MetronomeStatus.playing] if metronome is not running
  /// also starts the metronome
  void togglePlay() {
    if (state.currentBpm == 0) return;

    if (state.status == MetronomeStatus.playing) {
      _stopMetronome();

      emit(state.copyWith(status: MetronomeStatus.paused));
    } else {
      _timer = metronomeRepository.generateTimer(
        bar: state.currentBar,
        bpm: state.currentBpm,
        subdivision: state.currentSubdivision,
      );

      emit(state.copyWith(status: MetronomeStatus.playing));
    }
  }

  void _stopMetronome() {
    _timer?.cancel();
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await super.close();
  }
}
