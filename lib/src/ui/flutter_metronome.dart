import 'package:drumbitious_mvp/core/configs/config.dart';
import 'package:drumbitious_mvp/core/ui/ui.dart';
import 'package:drumbitious_mvp/core/utils/analytics.dart';
import 'package:drumbitious_mvp/core/widgets/buttons/round_button.dart';
import 'package:drumbitious_mvp/core/widgets/metronome/metronome.dart';
import 'package:drumbitious_mvp/data/models/bar.dart';
import 'package:drumbitious_mvp/data/repositories/audio_player_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MetronomeWidget extends StatelessWidget {
  final int initialBpm;
  final Function(int) onChangeBpm;

  const MetronomeWidget({
    super.key,
    required this.initialBpm,
    required this.onChangeBpm,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MetronomeCubit(
        audioPlayerRepository: context.read<AudioPlayerRepository>(),
        initialBpm: initialBpm,
      ),
      child: _MetronomeView(
        initialBpm: initialBpm,
        onChangeBpm: onChangeBpm,
      ),
    );
  }
}

class _MetronomeView extends StatefulWidget {
  final int initialBpm;
  final Function(int) onChangeBpm;

  const _MetronomeView({
    required this.initialBpm,
    required this.onChangeBpm,
  });

  @override
  State<_MetronomeView> createState() => _MetronomeViewState();
}

class _MetronomeViewState extends State<_MetronomeView> {
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
            padding: DrumbitiousSpacing.a8,
            color: DrumbitiousColors.primaryColorDark,
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
                    RoundButton(
                      size: 35,
                      child: const Text('-', style: DrumbitiousStyles.h2),
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
                              style: DrumbitiousStyles.h1,
                            ),
                          ),
                          const Text(
                            'BPM',
                            style: TextStyle(
                              color: DrumbitiousColors.accentColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RoundButton(
                      size: 35,
                      child: const Text('+', style: DrumbitiousStyles.h2),
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
                          activeColor: DrumbitiousColors.accentColor,
                          inactiveColor: DrumbitiousColors.primaryColorLight,
                          min: MIN_BPM.toDouble(),
                          max: MAX_BPM.toDouble(),
                          thumbColor: DrumbitiousColors.accentColor,
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
    Analytics.logEvent(
      name: AnalyticsEvent.changeMetronomeBarClicked,
      parameters: {
        'bar': '${newBar.noteCountPerBar}/${newBar.noteValue}',
      },
    );
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
      builder: (context, state) => RoundButton(
        size: 40,
        onPressed: () => context.read<MetronomeCubit>().togglePlay(),
        child: Icon(
          state == MetronomeStatus.paused
              ? Icons.play_arrow_rounded
              : Icons.pause_rounded,
          size: 35,
        ),
      ),
    );
  }
}
