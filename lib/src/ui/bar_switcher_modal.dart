import 'package:drumbitious_mvp/core/ui/drumbitious_colors.dart';
import 'package:drumbitious_mvp/core/ui/drumbitious_spacing.dart';
import 'package:drumbitious_mvp/core/ui/drumbitious_styles.dart';
import 'package:drumbitious_mvp/core/widgets/content_box.dart';
import 'package:drumbitious_mvp/data/models/bar.dart';
import 'package:flutter/material.dart';

class BarSwitcherModal extends StatefulWidget {
  final Function(Bar) onCloseDialog;
  final Bar? initialBar;

  const BarSwitcherModal({
    super.key,
    required this.onCloseDialog,
    required this.initialBar,
  });

  @override
  State<BarSwitcherModal> createState() => _BarSwitcherModalState();
}

class _BarSwitcherModalState extends State<BarSwitcherModal> {
  late List<Bar> _bars;

  late Bar _currentBar;

  @override
  void initState() {
    super.initState();

    _bars = <Bar>[
      const Bar(noteCountPerBar: 1, noteValue: NoteValue.quarter),
      const Bar(noteCountPerBar: 2, noteValue: NoteValue.quarter),
      const Bar(noteCountPerBar: 3, noteValue: NoteValue.quarter),
      const Bar(noteCountPerBar: 4, noteValue: NoteValue.quarter),
      const Bar(noteCountPerBar: 5, noteValue: NoteValue.quarter),
      const Bar(noteCountPerBar: 6, noteValue: NoteValue.quarter),
      const Bar(noteCountPerBar: 7, noteValue: NoteValue.quarter),
      const Bar(noteCountPerBar: 8, noteValue: NoteValue.quarter),
      const Bar(noteCountPerBar: 9, noteValue: NoteValue.quarter),
      const Bar(noteCountPerBar: 10, noteValue: NoteValue.quarter),
      const Bar(noteCountPerBar: 11, noteValue: NoteValue.quarter),
      const Bar(noteCountPerBar: 12, noteValue: NoteValue.quarter),
      const Bar(noteCountPerBar: 3, noteValue: NoteValue.eighth),
      const Bar(noteCountPerBar: 6, noteValue: NoteValue.eighth),
      const Bar(noteCountPerBar: 9, noteValue: NoteValue.eighth),
      const Bar(noteCountPerBar: 12, noteValue: NoteValue.eighth),
    ];

    _currentBar = widget.initialBar ?? _bars.first;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: BottomSheet(
        onClosing: () => widget.onCloseDialog(_currentBar),
        builder: (context) => DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            color: DrumbitiousColors.primaryColorLight,
          ),
          child: Center(
            child: GridView.count(
              crossAxisCount: 4,
              padding: DrumbitiousSpacing.a16,
              children: List.generate(
                _bars.length,
                (index) => GestureDetector(
                  onTap: () => _setCurrentBar(index, context),
                  child: Center(
                    child: ContentBox(
                      padding: const EdgeInsets.all(4),
                      color: _currentBar == _bars[index]
                          ? DrumbitiousColors.primaryColor
                          : DrumbitiousColors.primaryColorLight,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '${_bars[index].noteCountPerBar}/${_bars[index].noteValue.asInt()}',
                          style: DrumbitiousStyles.h2,
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

  void _setCurrentBar(int index, BuildContext context) {
    _currentBar = _bars[index];
    widget.onCloseDialog(_currentBar);
    Navigator.of(context).pop();
  }
}
