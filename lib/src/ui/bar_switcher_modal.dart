import 'package:flutter/material.dart';
import 'package:flutter_metronome/src/data/models/bar.dart';
import 'package:flutter_metronome/src/utils/metronome_config.dart';

class BarSwitcherModal extends StatefulWidget {
  final void Function(Bar) onCloseDialog;
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
  late Bar _currentBar;

  @override
  void initState() {
    super.initState();

    _currentBar = widget.initialBar ?? MetronomeConfig.AVAILABLE_BARS.first;
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
            color: Colors.blueAccent,
          ),
          child: Center(
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.all(16),
              children: List.generate(
                MetronomeConfig.AVAILABLE_BARS.length,
                (index) => GestureDetector(
                  onTap: () => _setCurrentBar(index, context),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      color:
                          _currentBar == MetronomeConfig.AVAILABLE_BARS[index]
                              ? Colors.blue.shade500
                              : Colors.blue.shade900,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '${MetronomeConfig.AVAILABLE_BARS[index].noteCountPerBar}/${MetronomeConfig.AVAILABLE_BARS[index].noteValue.asInt()}',
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
    _currentBar = MetronomeConfig.AVAILABLE_BARS[index];
    widget.onCloseDialog(_currentBar);
    Navigator.of(context).pop();
  }
}
