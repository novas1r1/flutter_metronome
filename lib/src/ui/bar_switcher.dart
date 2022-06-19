import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_metronome/src/cubits/metronome_cubit.dart';
import 'package:flutter_metronome/src/data/models/bar.dart';
import 'package:flutter_metronome/src/ui/bar_switcher_modal.dart';

class BarSwitcher extends StatelessWidget {
  final void Function(Bar) onChangeBar;

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
        ),
      ),
    );
  }
}
