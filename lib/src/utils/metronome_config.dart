import 'package:flutter_metronome/src/data/models/bar.dart';

class MetronomeConfig {
  MetronomeConfig._();

  static const MIN_BPM = 0;
  static const MAX_BPM = 240;
  static const DEFAULT_BPM = 120;

  static const AVAILABLE_BARS = <Bar>[
    Bar(noteCountPerBar: 1, noteValue: NoteValue.quarter),
    Bar(noteCountPerBar: 2, noteValue: NoteValue.quarter),
    Bar(noteCountPerBar: 3, noteValue: NoteValue.quarter),
    Bar(noteCountPerBar: 4, noteValue: NoteValue.quarter),
    Bar(noteCountPerBar: 5, noteValue: NoteValue.quarter),
    Bar(noteCountPerBar: 6, noteValue: NoteValue.quarter),
    Bar(noteCountPerBar: 7, noteValue: NoteValue.quarter),
    Bar(noteCountPerBar: 8, noteValue: NoteValue.quarter),
    Bar(noteCountPerBar: 9, noteValue: NoteValue.quarter),
    Bar(noteCountPerBar: 10, noteValue: NoteValue.quarter),
    Bar(noteCountPerBar: 11, noteValue: NoteValue.quarter),
    Bar(noteCountPerBar: 12, noteValue: NoteValue.quarter),
    Bar(noteCountPerBar: 3, noteValue: NoteValue.eighth),
    Bar(noteCountPerBar: 6, noteValue: NoteValue.eighth),
    Bar(noteCountPerBar: 9, noteValue: NoteValue.eighth),
    Bar(noteCountPerBar: 12, noteValue: NoteValue.eighth),
  ];
}
