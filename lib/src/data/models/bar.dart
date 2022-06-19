enum NoteValue {
  // 1
  whole,
  // 1/2
  half,
  // 1/3
  triplet,
  // 1/4
  quarter,
  // 1/8
  eighth,
  // 1/16
  sixteenth,
  // 1/32
  thirtySecondNote,
  // 1/64
  sixtyFourthNote,
}

class Bar {
  const Bar({
    required this.noteValue,
    required this.noteCountPerBar,
  });
  final NoteValue noteValue;
  final int noteCountPerBar;

  @override
  String toString() =>
      'Bar(noteValue: ${noteValue.name}, noteCountPerBar: $noteCountPerBar)';

  Bar copyWith({
    NoteValue? noteValue,
    int? noteCountPerBar,
  }) {
    return Bar(
      noteValue: noteValue ?? this.noteValue,
      noteCountPerBar: noteCountPerBar ?? this.noteCountPerBar,
    );
  }
}

extension NoteValueParser on NoteValue {
  int asInt() {
    switch (this) {
      case NoteValue.whole:
        return 1;
      case NoteValue.half:
        return 2;
      case NoteValue.triplet:
        return 3;
      case NoteValue.quarter:
        return 4;
      case NoteValue.eighth:
        return 8;
      case NoteValue.sixteenth:
        return 16;
      case NoteValue.thirtySecondNote:
        return 32;
      case NoteValue.sixtyFourthNote:
        return 64;
    }
  }

  String iconName() {
    switch (this) {
      case NoteValue.whole:
        return 'ic_note_whole';
      case NoteValue.half:
        return 'ic_note_half';
      case NoteValue.triplet:
        return 'ic_note_triplet';
      case NoteValue.quarter:
        return 'ic_note_quarter';
      case NoteValue.eighth:
        return 'ic_note_eight';
      case NoteValue.sixteenth:
        return 'ic_note_sixteenth';
      case NoteValue.thirtySecondNote:
        return 'ic_note_thirtySecondNote';
      case NoteValue.sixtyFourthNote:
        return 'ic_note_sixtyFourthNote';
    }
  }
}
