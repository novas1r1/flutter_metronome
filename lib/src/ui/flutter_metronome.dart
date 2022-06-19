import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_metronome/src/cubits/metronome_cubit.dart';
import 'package:flutter_metronome/src/data/models/bar.dart';
import 'package:flutter_metronome/src/data/repositories/metronome_repository.dart';
import 'package:flutter_metronome/src/ui/bar_switcher.dart';
import 'package:flutter_metronome/src/ui/note_value_switcher.dart';
import 'package:flutter_metronome/src/utils/metronome_config.dart';

class FlutterMetronome extends StatelessWidget {
  /// Initial BPM displayed by the metronome, defaults to 120
  final int initialBpm;

  /// Maximum BPM allowed by the metronome, defaults to 240
  final int maxBpm;

  /// Minimum BPM allowed by the metronome, defaults to 0
  final int minBpm;

  /// If bpm was changed by the widget, this callback will be called
  final void Function(int)? onChangeBpm;

  /// Initial bar is displayed by the metronome,
  /// defaults to Bar(noteCountPerBar: 4, noteValue: NoteValue.quarter)
  final Bar initialBar;

  const FlutterMetronome({
    super.key,
    this.initialBpm = MetronomeConfig.DEFAULT_BPM,
    this.maxBpm = MetronomeConfig.MAX_BPM,
    this.minBpm = MetronomeConfig.MIN_BPM,
    this.initialBar =
        const Bar(noteValue: NoteValue.quarter, noteCountPerBar: 4),
    this.onChangeBpm,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MetronomeRepository(),
      child: BlocProvider(
        create: (context) => MetronomeCubit(
          metronomeRepository: context.read<MetronomeRepository>(),
          initialBar: initialBar,
          initialBpm: initialBpm,
          maxBpm: maxBpm,
          minBpm: minBpm,
        ),
        child: _FlutterMetronomeView(
          onChangeBpm: onChangeBpm,
        ),
      ),
    );
  }
}

class _FlutterMetronomeView extends StatelessWidget {
  final void Function(int)? onChangeBpm;

  const _FlutterMetronomeView({this.onChangeBpm});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MetronomeCubit, MetronomeState>(
      listenWhen: (previous, current) =>
          previous.currentBpm != current.currentBpm,
      listener: (context, state) => onChangeBpm?.call(state.currentBpm),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 50,
                      child: BarSwitcher(
                        onChangeBar: (newBar) => _onChangeBar(newBar, context),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () =>
                          context.read<MetronomeCubit>().decreaseBpm(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlocSelector<MetronomeCubit, MetronomeState, int>(
                            selector: (state) => state.currentBpm,
                            builder: (context, state) => Text('$state'),
                          ),
                          const Text(
                            'BPM',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () =>
                          context.read<MetronomeCubit>().increaseBpm(),
                    ),
                    SizedBox(
                      width: 50,
                      child: NoteValueSwitcher(
                        onChangeNoteValue: (newValue) => context
                            .read<MetronomeCubit>()
                            .changeSubdivision(newValue),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const _MetronomePlayButton(),
                    Expanded(
                      child: BlocSelector<MetronomeCubit, MetronomeState, int>(
                        selector: (state) => state.currentBpm,
                        builder: (context, state) => Slider(
                          min: MetronomeConfig.MIN_BPM.toDouble(),
                          max: MetronomeConfig.MAX_BPM.toDouble(),
                          value: state.toDouble(),
                          onChanged: (newValue) =>
                              _onChangeBpm(context, newValue),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onChangeBar(Bar newBar, BuildContext context) {
    context.read<MetronomeCubit>().changeBar(newBar);
  }

  void _onChangeBpm(BuildContext context, double newValue) {
    context.read<MetronomeCubit>().setBpm(newValue.toInt());
  }
}

class _MetronomePlayButton extends StatelessWidget {
  const _MetronomePlayButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MetronomeCubit, MetronomeState, MetronomeStatus>(
      selector: (state) => state.status,
      builder: (context, state) => IconButton(
        onPressed: () => context.read<MetronomeCubit>().togglePlay(),
        icon: Icon(
          state == MetronomeStatus.paused
              ? Icons.play_arrow_rounded
              : Icons.pause_rounded,
          size: 35,
        ),
      ),
    );
  }
}
