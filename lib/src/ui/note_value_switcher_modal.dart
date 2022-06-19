import 'package:flutter/material.dart';
import 'package:flutter_metronome/src/data/models/bar.dart';
import 'package:flutter_metronome/src/utils/metronome_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoteValueSwitcherModal extends StatefulWidget {
  final void Function(NoteValue) onCloseDialog;
  final NoteValue? initialNoteValue;

  const NoteValueSwitcherModal({
    super.key,
    required this.onCloseDialog,
    required this.initialNoteValue,
  });

  @override
  State<NoteValueSwitcherModal> createState() => _NoteValueSwitcherModalState();
}

class _NoteValueSwitcherModalState extends State<NoteValueSwitcherModal> {
  late NoteValue _currentNoteValue;
  late List<NoteValue> _noteValues;

  @override
  void initState() {
    super.initState();
    _noteValues = MetronomeConfig.AVAILABLE_NOTE_VALUES;

    _currentNoteValue = widget.initialNoteValue ?? _noteValues.first;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: BottomSheet(
        onClosing: () => widget.onCloseDialog(_currentNoteValue),
        builder: (context) => DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Center(
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.all(16),
              children: List.generate(
                _noteValues.length,
                (index) => GestureDetector(
                  onTap: () => _setCurrentNoteValue(index, context),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      color: _currentNoteValue ==
                              MetronomeConfig.AVAILABLE_NOTE_VALUES[index]
                          ? Colors.primaries.first
                          : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          'assets/images/${_noteValues[index].iconName()}.svg',
                          package: 'flutter_metronome',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setCurrentNoteValue(int index, BuildContext context) {
    _currentNoteValue = _noteValues[index];
    widget.onCloseDialog(_currentNoteValue);
    Navigator.of(context).pop();
  }
}
