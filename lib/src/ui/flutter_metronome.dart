import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_metronome/src/cubits/metronome_cubit.dart';
import 'package:flutter_metronome/src/data/models/bar.dart';
import 'package:flutter_metronome/src/data/repositories/metronome_repository.dart';
import 'package:flutter_metronome/src/ui/bar_switcher.dart';
import 'package:flutter_metronome/src/ui/note_value_switcher.dart';
import 'package:flutter_metronome/src/utils/metronome_config.dart';

class FlutterMetronome extends StatelessWidget {
  final int initialBpm;
  final Function(int) onChangeBpm;
  final Color color;

  const FlutterMetronome({
    super.key,
    required this.initialBpm,
    required this.onChangeBpm,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MetronomeRepository(),
      child: BlocProvider(
        create: (context) => MetronomeCubit(
          metronomeRepository: context.read<MetronomeRepository>(),
          initialBpm: initialBpm,
        ),
        child: _FlutterMetronomeView(
          initialBpm: initialBpm,
          onChangeBpm: onChangeBpm,
          color: color,
        ),
      ),
    );
  }
}

class _FlutterMetronomeView extends StatefulWidget {
  final int initialBpm;
  final Function(int) onChangeBpm;
  final Color color;

  const _FlutterMetronomeView({
    required this.initialBpm,
    required this.onChangeBpm,
    required this.color,
  });

  @override
  State<_FlutterMetronomeView> createState() => _FlutterMetronomeViewState();
}

class _FlutterMetronomeViewState extends State<_FlutterMetronomeView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MetronomeCubit, MetronomeState>(
      listenWhen: (previous, current) =>
          previous.currentBpm != current.currentBpm,
      listener: (context, state) => widget.onChangeBpm(state.currentBpm),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: widget.color,
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
                            builder: (context, state) => Text(
                              '$state',
                            ),
                          ),
                          const Text(
                            'BPM',
                            style: TextStyle(
                              fontSize: 20,
                            ),
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
                              onChangeBpm(context, newValue),
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

  void onChangeBpm(BuildContext context, double newValue) {
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
