import 'package:fluter_intern_tech_master/2/optimize/chat_bouble.dart';
import 'package:fluter_intern_tech_master/2/optimize/optimize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toml/toml.dart';
import 'package:just_audio/just_audio.dart' as ja;

void main() => runApp(const Bai3());

class Bai3 extends StatelessWidget {
  const Bai3({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'chat bubble example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static ja.AudioPlayer player = ja.AudioPlayer();
  String img_url = "";
  String user = "Lan";
  List<dynamic> all_dialog = [];
  int event_cursor = 0;
  List<dynamic> events = [];
  String all_text = "";
  List<dynamic> timestamp = [];
  List<int> hight_lighting = [-1, -1];
  List<dynamic> format = [];
  List<Line_data> line_data_list = [];
  int hl = -1;
  @override
  void initState() {
    super.initState();
    prepareData().then(
      (value) async {
        await player.setAsset('assets/audio/ouput.wav');
        listen_data(0);
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void listen_data(int hight_light_cursor) {
    const tolerance = 50;

    player.positionStream.listen((position) {
      final currentMillis = position.inMilliseconds;

      for (var i = 0; i < events.length; i++) {
        final eventMillis = events[i][0];
        if ((currentMillis - eventMillis).abs() <= tolerance) {
          setState(() {
            img_url = "assets/image/${events[i][2]}";
          });
        }
      }
      if (hight_light_cursor >= timestamp.length) return;
      find(timestamp, hight_lighting, currentMillis);
    });
    playAudioFrom(0);
  }

  void find(
      List<dynamic> timestamp, List<int> hight_lighting, int currentMillis) {
    for (int i = 0; i < timestamp.length; i++) {
      if ((currentMillis - timestamp[i][0]).abs() <= 20) {
        int count = i;
        for (var j = 0; j < line_data_list.length; j++) {
          for (int k = 0; k < line_data_list[j].words_data.length; k++) {
            count--;
            if (line_data_list[j].words_data[k].hight_lighting = true) {
              setState(() {
                line_data_list[j].words_data[k].hight_lighting = false;
              });
            }
            if (count == 0) {
              setState(() {
                line_data_list[j].words_data[k].hight_lighting = true;
              });
            }
          }
        }
      }
    }
  }

  int countWords(String input) {
    RegExp regex = RegExp(r"[\p{L}\p{N}'\-]+|[.,!?;]", unicode: true);
    List<String> matches =
        regex.allMatches(input).map((match) => match.group(0)!).toList();
    return matches.length;
  }

  Future<void> prepareData() async {
    final tomlString = await rootBundle.loadString('assets/ouput.toml');
    final config = TomlDocument.parse(tomlString).toMap();

    // Truy xuất thông tin từ file TOML
    events = config['event']['data'] as List<dynamic>;
    all_dialog = config['text']['dialog'];
    all_text = config["text"]["data"];
    timestamp = config['timestamp']['data'];
    format = config['text']['format'];
    int cur = 0;

    for (int i = 0; i < all_dialog.length; i++) {
      Line_data line_data = Line_data(
          speaker: all_dialog[i]['speaker'] == user,
          words_data: [],
          bouble_color: all_dialog[i]['speaker'] == user
              ? const Color.fromARGB(255, 155, 196, 226)
              : const Color.fromARGB(255, 216, 216, 216),
          time_start: 0);

      for (int j = 0; j < timestamp.length; j++) {
        if (timestamp[j][4] == cur) {
          line_data.time_start = timestamp[j][0];
        }
      }
      line_data_list.add(line_data);

      cur += all_dialog[i]['text'].toString().length + 1;
    }

    List<Word_data> word_data_list = [];
    for (int j = 0; j < timestamp.length; j++) {
      Word_data word_data = Word_data(
          text: timestamp[j][3],
          hight_lighting: false,
          length: (j + 1 < timestamp.length)
              ? (timestamp[j + 1][4] - timestamp[j][4])
              : timestamp[j][5],
          start_index: timestamp[j][4]);
      word_data_list.add(word_data);
    }

    addStyle(format, word_data_list);

    int ok = 0;
    for (int i = 0; i < all_dialog.length; i++) {
      int count = countWords(all_dialog[i]['text']);
      for (int j = ok; j < ok + count; j++) {
        line_data_list[i].words_data.add(word_data_list[j]);
      }
      ok += count;
    }

    int a = 0;
  }

  Future<void> addStyle(
      List<dynamic> format, List<Word_data> word_data_list) async {
    for (var i = 0; i < format.length; i++) {
      int start_at = format[i]['position'][0];
      int end_at = countWords(format[i]['position'][1]);
      for (var j = 0; j < word_data_list.length; j++) {
        if (start_at == word_data_list[j].start_index) {
          TextStyle textStyle = TextStyle(
            color: Color(
              int.parse(
                      (format[i]['style']['color'] ?? '0xFF000000')
                          .substring(1),
                      radix: 16) +
                  0xFF000000,
            ),
            fontWeight: format[i]['style']['bold']
                ? FontWeight.bold
                : FontWeight.normal,
            fontStyle: format[i]['style']['italic']
                ? FontStyle.italic
                : FontStyle.normal,
            decoration: format[i]['style']['underline']
                ? TextDecoration.underline
                : TextDecoration.none,
          );
          for (int k = 0; k < end_at; k++) {
            word_data_list[j + k].textStyle = textStyle;
          }
        }
      }
    }
  }

  Future<void> playAudioFrom(int fromMs) async {
    await player.stop();
    await player.seek(Duration(milliseconds: fromMs));
    await player.play();
  }

  @override
  void dispose() {
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
              duration:
                  const Duration(milliseconds: 500), // Thời gian chuyển ảnh
              child: img_url.isEmpty
                  ? Container()
                  : Image.asset(
                      img_url,
                      key: ValueKey<String>(
                          img_url), // Sử dụng key để xác định ảnh mới
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  children: List.generate(
                line_data_list.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      playAudioFrom(line_data_list[index].time_start);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Chat_Bouble(line_data: line_data_list[index]),
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
