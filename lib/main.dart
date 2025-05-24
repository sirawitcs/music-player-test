import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_test/widget/custom_listile.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'My Playlist'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlay = false;
  List items = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    readJson();
    player.positionStream.listen((currentPosition) {
      setState(() {
        position = currentPosition;
      });
    });
    player.durationStream.listen((currentDuration) {
      duration = currentDuration ?? Duration.zero;
    });
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString(
      'assets/json/song_list.json',
    );
    final data = await json.decode(response);
    setState(() {
      items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    void selectSound(int index) async {
      try {
        await player.setAsset(items[index]['song']);
        player.play();
      } on PlayerException catch (e) {
        print("Error loading audio source: $e");
      }
      if (isPlay) {
        player.seek(Duration(seconds: 0));
      } else {
        player.play();
      }

      setState(() {
        isPlay = true;
        selectedIndex = index;
      });
    }

    void playAction() async {
      if (isPlay) {
        player.stop();
        setState(() {
          isPlay = false;
        });
      } else {
        player.play();
        setState(() {
          isPlay = true;
        });
      }
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return CustomListile(
              image: items[index]['image'],
              title: items[index]['song_name'],
              subTitlt: items[index]['artist_name'],
              listiltAction: () {
                selectSound(index);
              },
              buttonAction: () {
                selectSound(index);
              },
              icon: Icon(Icons.play_circle_outline),
            );
          },
        ),
        bottomNavigationBar:
            duration.inSeconds.toDouble() != 0
                ? Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Slider(
                        min: 0,
                        max: duration.inSeconds.toDouble(),
                        value: position.inSeconds.toDouble(),
                        onChanged: (value) async {
                          player.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                      CustomListile(
                        image: items[selectedIndex]['image'],
                        title: items[selectedIndex]['song_name'],
                        subTitlt: items[selectedIndex]['artist_name'],
                        listiltAction: () {},
                        buttonAction: () {
                          playAction();
                        },
                        icon: Icon(isPlay ? Icons.stop : Icons.play_arrow),
                      ),
                    ],
                  ),
                )
                : SizedBox.shrink(),
      ),
    );
  }
}
