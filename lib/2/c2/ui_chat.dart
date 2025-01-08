import 'dart:async';

import 'package:fluter_intern_tech_master/2/chat_bouble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toml/toml.dart';
import 'package:just_audio/just_audio.dart' as ja;

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  ja.AudioPlayer player = ja.AudioPlayer();
  String img_url = "";
  String user = "Lan";
  List<dynamic> all_dialog = [];
  List<dynamic> events = [];
  List<dynamic> timestamp = [];
  List<int> high_lighting = [-1, -1];
  List<dynamic> format = [];
  late StreamSubscription _subscription;
  @override
  void initState() {
    super.initState();
    prepare_data().then(
      (value) async {
        await player.setAsset('assets/audio/ouput.wav');
        listen_data(0);
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

// lắng nghe stream audio -> cập nhật theo yêu cầu đề bài
  void listen_data(int highLightCursor) {
    const tolerance = 50;

    _subscription = player.positionStream.listen((position) {
      final currentMillis = position.inMilliseconds;
      for (var i = 0; i < events.length; i++) {
        final eventMillis = events[i][0];
        if ((currentMillis - eventMillis).abs() <= tolerance) {
          setState(() {
            img_url = "assets/image/${events[i][2]}";
          });
        }
      }

      if (highLightCursor >= timestamp.length) return;
      find(timestamp, high_lighting, currentMillis);
    });
    playAudioFrom(0);
  }

// tìm đoạn cần highlight
  void find(
      List<dynamic> timestamp, List<int> highLighting, int currentMillis) {
    for (int i = 0; i < timestamp.length; i++) {
      if ((currentMillis - timestamp[i][0]).abs() <= 30) {
        setState(() {
          highLighting[0] = timestamp[i][4];
          highLighting[1] = timestamp[i][4] + timestamp[i][5] - 1;
        });
        return;
      }
    }
  }

// load dữ liệu từ file toml
  Future<void> prepare_data() async {
    final tomlString = await rootBundle.loadString('assets/ouput.toml');
    final config = TomlDocument.parse(tomlString).toMap();

    events = config['event']['data'] as List<dynamic>;
    all_dialog = config['text']['dialog'];
    timestamp = config['timestamp']['data'];
    format = config['text']['format'];
    int cur = 0;

    for (int i = 0; i < all_dialog.length; i++) {
      for (int j = 0; j < timestamp.length; j++) {
        if (timestamp[j][4] == cur) {
          all_dialog[i]['time_start'] = timestamp[j][0];
          all_dialog[i]['start_index'] = cur;
        }
      }
      cur += all_dialog[i]['text'].toString().length + 1;
    }
  }

// phát audio
  Future<void> playAudioFrom(int fromMs) async {
    await player.stop();
    await player.seek(Duration(milliseconds: fromMs));
    await player.play();
  }

  @override
  void dispose() {
    _subscription.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: img_url.isEmpty
                  ? Container()
                  : Image.asset(
                      img_url,
                      key: ValueKey<String>(img_url),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  children: List.generate(
                all_dialog.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      playAudioFrom(all_dialog[index]['time_start']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Chat_Bouble(
                        format: format,
                        start_index: all_dialog[index]['start_index'],
                        start_high_light: high_lighting[0],
                        end_high_light: high_lighting[1],
                        text: all_dialog[index]['text'],
                        color: (all_dialog[index]['speaker'] == user)
                            ? const Color.fromARGB(255, 155, 196, 226)
                            : const Color.fromARGB(255, 216, 216, 216),
                        is_sender: (all_dialog[index]['speaker'] != user),
                      ),
                    ),
                  );
                },
              )),
            ),
          ),
        ],
      ),
    );
  }
}
