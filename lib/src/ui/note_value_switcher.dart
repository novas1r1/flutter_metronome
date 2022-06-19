import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_metronome/src/cubits/metronome_cubit.dart';
import 'package:flutter_metronome/src/data/models/bar.dart';
import 'package:flutter_metronome/src/ui/note_value_switcher_modal.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoteValueSwitcher extends StatelessWidget {
  final void Function(NoteValue) onChangeNoteValue;

  const NoteValueSwitcher({super.key, required this.onChangeNoteValue});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MetronomeCubit, MetronomeState, NoteValue>(
      selector: (state) => state.currentSubdivision,
      builder: (context, state) => GestureDetector(
        onTap: () => showModalBottomSheet<NoteValue>(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => NoteValueSwitcherModal(
            initialNoteValue: state,
            onCloseDialog: onChangeNoteValue,
          ),
        ),
        child: SizedBox(
          height: 24,
          width: 24,
          child: SvgPicture.asset(
            'images/${state.iconName()}.svg',
            package: 'flutter_metronome',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
