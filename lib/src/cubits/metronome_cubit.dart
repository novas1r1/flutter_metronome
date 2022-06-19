import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_metronome/src/data/models/bar.dart';
import 'package:flutter_metronome/src/data/repositories/metronome_repository.dart';
import 'package:flutter_metronome/src/utils/metronome_config.dart';

part 'metronome_state.dart';

class MetronomeCubit extends Cubit<MetronomeState> {
  final MetronomeRepository metronomeRepository;
  final int initialBpm;
  final Bar initialBar;
  final NoteValue initialSubdivision;

  MetronomeCubit({
    this.initialBar =
        const Bar(noteValue: NoteValue.quarter, noteCountPerBar: 4),
    required this.initialBpm,
    this.initialSubdivision = NoteValue.quarter,
    required this.metronomeRepository,
  }) : super(
          MetronomeState(
            initialBpm: initialBpm,
            currentBpm: initialBpm,
            currentBar: initialBar,
            currentSubdivision: initialSubdivision,
          ),
        ) {
    // metronomeRepository.initializeMetronome();
  }

  Timer? _timer;

  void increaseBpm({int step = 1}) {
    _stop();

    if (state.currentBpm + step > MetronomeConfig.MAX_BPM) {
      emit(
        state.copyWith(
          status: MetronomeStatus.paused,
          currentBpm: MetronomeConfig.MAX_BPM,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: MetronomeStatus.paused,
          currentBpm: state.currentBpm + step,
        ),
      );
    }
  }

  void decreaseBpm({int step = 1}) {
    _stop();
    if (state.currentBpm >= step) {
      emit(
        state.copyWith(
          status: MetronomeStatus.paused,
          currentBpm: state.currentBpm - step,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: MetronomeStatus.paused,
          currentBpm: 0,
        ),
      );
    }
  }

  void setBpm(int newBpm) {
    _stop();

    emit(
      state.copyWith(status: MetronomeStatus.paused, currentBpm: newBpm),
    );
  }

  void changeBar(Bar newBar) {
    _stop();

    emit(state.copyWith(status: MetronomeStatus.paused, currentBar: newBar));
  }

  void changeSubdivision(NoteValue newValue) {
    _stop();

    emit(
      state.copyWith(
        status: MetronomeStatus.paused,
        currentSubdivision: newValue,
      ),
    );
  }

  void _stop() {
    _timer?.cancel();
  }

  // 120 bpm = 60/120 = tick every 0.5 seconds = 0.5 * 1000 = 500 ms
  // 60 bpm = 60/60 = tick every 1 second = 1 * 1000 = 1000 ms
  void togglePlay() {
    if (state.currentBpm == 0) {
      return;
    }

    if (state.status == MetronomeStatus.playing) {
      emit(state.copyWith(status: MetronomeStatus.paused));
      _stop();
    } else {
      emit(state.copyWith(status: MetronomeStatus.playing));

      _timer = metronomeRepository.generateTimer(
        bar: state.currentBar,
        bpm: state.currentBpm,
        subdivision: state.currentSubdivision,
      );
    }
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await super.close();
  }
}
