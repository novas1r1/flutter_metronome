import 'package:drumbitious_mvp/core/ui/drumbitious_styles.dart';
import 'package:drumbitious_mvp/core/widgets/metronome/metronome.dart';
import 'package:drumbitious_mvp/data/models/bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BarSwitcher extends StatelessWidget {
  final Function(Bar) onChangeBar;

  const BarSwitcher({
    super.key,
    required this.onChangeBar,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MetronomeCubit, MetronomeState, Bar>(
      selector: (state) => state.currentBar,
      builder: (context, state) => GestureDetector(
        onTap: () => showModalBottomSheet<Bar>(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => BarSwitcherModal(
            initialBar: state,
            onCloseDialog: onChangeBar,
          ),
        ),
        child: Text(
          '${state.noteCountPerBar}/${state.noteValue.asInt()}',
          style: DrumbitiousStyles.h15,
        ),
      ),
    );
  }
}
