import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_metronome/src/data/models/bar.dart';
import 'package:soundpool/soundpool.dart';

const SOUND_METRONOME_ELECTRIC = 'assets/sounds/metronome_electric.wav';
const SOUND_METRONOME_ELECTRIC_UP = 'assets/sounds/metronome_electric_up.wav';

class MetronomeRepository {
  late final Soundpool _soundpool;

  late int metronomeId;
  late int metronomeUpId;

  MetronomeRepository({
    Soundpool? soundpool,
  }) : _soundpool = soundpool ??
            Soundpool.fromOptions(
              options: const SoundpoolOptions(maxStreams: 3),
            );

  Future<void> initializeMetronome() async {
    metronomeId =
        await rootBundle.load(SOUND_METRONOME_ELECTRIC).then(_soundpool.load);
    metronomeUpId = await rootBundle
        .load(SOUND_METRONOME_ELECTRIC_UP)
        .then(_soundpool.load);
  }

  Future<int> playMetronomeSound() async => _soundpool.play(metronomeId);

  Future<int> playMetronomeUpSound() async => _soundpool.play(metronomeUpId);

  Timer generateTimer({
    required Bar bar,
    required int bpm,
    required NoteValue subdivision,
  }) {
    final tickRate = _generateTickRate(subdivision, bpm);

    var needsTick = true;
    var millisLastTick = DateTime.now().microsecondsSinceEpoch;

    var ticksOverall = 0;

    final noUpNoteCount =
        _generateNoUpNoteCount(subdivision, bar.noteCountPerBar);

    return Timer.periodic(
      const Duration(microseconds: 500),
      (timer) async {
        final now = DateTime.now().microsecondsSinceEpoch;
        final duration = now - millisLastTick;

        if (duration >= tickRate && needsTick) {
          if (ticksOverall % noUpNoteCount == 0) {
            await playMetronomeUpSound();
          } else {
            await playMetronomeSound();
          }

          millisLastTick = now;
          needsTick = false;
          ticksOverall++;
        }

        if (duration < tickRate) {
          needsTick = true;
        }
      },
    );
  }

  /// This generates the tickRate based on the given subdivision and bpm.
  /// Currently only eighth, triplet and sixteenth notes are supported
  int _generateTickRate(NoteValue subdivision, int bpm) {
    const seconds = 60;
    const milliSeconds = seconds * 1000;
    const microSeconds = milliSeconds * 1000;

    int tickRate;

    switch (subdivision) {
      case NoteValue.eighth:
        tickRate = (microSeconds / bpm / 2).round();
        break;
      case NoteValue.triplet:
        tickRate = (microSeconds / bpm / 3).round();
        break;
      case NoteValue.sixteenth:
        tickRate = (microSeconds / bpm / 4).round();
        break;
      case NoteValue.whole:
      case NoteValue.half:
      case NoteValue.thirtySecondNote:
      case NoteValue.sixtyFourthNote:
      case NoteValue.quarter:
        tickRate = (microSeconds / bpm).round();
        break;
    }

    return tickRate;
  }

  /// This generates the number of notes that are not up.
  /// For e.g. noteCountPerBar = 4, subdivision = eighth makes noUpNoteCount = 8
  /// per bar.
  int _generateNoUpNoteCount(NoteValue subdivision, int noteCountPerBar) {
    var noUpNoteCount = noteCountPerBar;

    switch (subdivision) {
      case NoteValue.triplet:
        noUpNoteCount = noteCountPerBar * 3;
        break;
      case NoteValue.eighth:
        noUpNoteCount = noteCountPerBar * 2;
        break;
      case NoteValue.sixteenth:
        noUpNoteCount = noteCountPerBar * 4;
        break;
      case NoteValue.whole:
      case NoteValue.half:
      case NoteValue.thirtySecondNote:
      case NoteValue.sixtyFourthNote:
      case NoteValue.quarter:
        break;
    }

    return noUpNoteCount;
  }
}
