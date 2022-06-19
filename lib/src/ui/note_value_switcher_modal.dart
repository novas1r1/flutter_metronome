import 'package:drumbitious_mvp/core/ui/drumbitious_colors.dart';
import 'package:drumbitious_mvp/core/ui/drumbitious_spacing.dart';
import 'package:drumbitious_mvp/core/ui/svg_icon.dart';
import 'package:drumbitious_mvp/core/utils/analytics.dart';
import 'package:drumbitious_mvp/core/widgets/content_box.dart';
import 'package:drumbitious_mvp/data/models/bar.dart';
import 'package:flutter/material.dart';

class NoteValueSwitcherModal extends StatefulWidget {
  final Function(NoteValue) onCloseDialog;
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
  late List<NoteValue> _noteValues;

  late NoteValue _currentNoteValue;

  @override
  void initState() {
    super.initState();

    _noteValues = [
      NoteValue.quarter,
      NoteValue.eighth,
      NoteValue.triplet,
      NoteValue.sixteenth,
    ];

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
            color: DrumbitiousColors.primaryColorLight,
          ),
          child: Center(
            child: GridView.count(
              crossAxisCount: 4,
              padding: DrumbitiousSpacing.a16,
              children: List.generate(
                _noteValues.length,
                (index) => GestureDetector(
                  onTap: () => _setCurrentNoteValue(index, context),
                  child: Center(
                    child: ContentBox(
                      padding: const EdgeInsets.all(4),
                      color: _currentNoteValue == _noteValues[index]
                          ? DrumbitiousColors.primaryColor
                          : DrumbitiousColors.primaryColorLight,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SvgIcon(
                          name: _noteValues[index].iconName(),
                          size: 42,
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
    Analytics.logEvent(
      name: AnalyticsEvent.changeNoteValueClicked,
      parameters: {
        'noteValue': _noteValues[index].toString(),
      },
    );

    _currentNoteValue = _noteValues[index];
    widget.onCloseDialog(_currentNoteValue);
    Navigator.of(context).pop();
  }
}
