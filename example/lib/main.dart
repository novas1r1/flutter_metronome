import 'package:flutter/material.dart';
import 'package:flutter_metronome/flutter_metronome.dart';

import 'ffi.dart' show api;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MetronomePage(),
    );
  }
}

class MetronomePage extends StatefulWidget {
  const MetronomePage({super.key});

  @override
  State<MetronomePage> createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> {
  @override
  void initState() {
    super.initState();
    api.main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metronome Test'),
      ),
      body: FlutterMetronome(
        initialBpm: 120,
        minBpm: 0,
        maxBpm: 200,
        onChangeBpm: (int bpm) {
          print('bpm: $bpm');
        },
      ),
    );
  }
}
