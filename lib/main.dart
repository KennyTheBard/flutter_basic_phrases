import 'dart:async' show Future;

// ignore: import_of_legacy_library_into_null_safe
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'League of Voices',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'League of Voices'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    loadAsset().then((List<List<String>> value) => elements = value);
  }

  AudioPlayer audioPlugin = AudioPlayer();
  List<List<String>> elements = <List<String>>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: GridView.builder(
                itemCount: elements.length,
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 16.0, crossAxisSpacing: 16.0, childAspectRatio: 1.0),
                itemBuilder: (BuildContext context, int index) {
                  return Item(
                    index: index,
                    element: elements[index],
                    audioPlugin: audioPlugin,
                  );
                })));
  }
}

class Item extends StatelessWidget {
  const Item({Key? key, required this.index, required this.element, required this.audioPlugin}) : super(key: key);
  final int index;
  final AudioPlayer audioPlugin;
  final List<String> element;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (audioPlugin.state == AudioPlayerState.PLAYING) {
            audioPlugin.stop();
          }
          audioPlugin.play(element[2]);
        },
        child: FittedBox(
          child: Image.network(element[1]),
          fit: BoxFit.fill,
        ));
  }
}

Future<List<List<String>>> loadAsset() async {
  try {
    return List<List<String>>.of(
        (await rootBundle.loadString('assets/lol_data.csv')).split('\n').map((String e) => e.split(',')));
  } catch (err) {
    return List<List<String>>.of(<List<String>>[]);
  }
}
