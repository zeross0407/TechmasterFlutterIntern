import 'package:flutter/material.dart';

class Chat_Bouble extends StatefulWidget {
  final Color color;
  final bool is_sender;
  final String text;
  final int start_high_light;
  final int end_high_light;
  final int start_index;
  final List<dynamic> format;
  const Chat_Bouble(
      {super.key,
      required this.color,
      required this.is_sender,
      required this.text,
      required this.start_high_light,
      required this.end_high_light,
      required this.start_index,
      required this.format});

  @override
  State<Chat_Bouble> createState() => _Chat_BoubleState();
}

class _Chat_BoubleState extends State<Chat_Bouble> {
// load text style
  TextStyle? check_style(int index) {
    for (var i = 0; i < widget.format.length; i++) {
      if (widget.format[i]['position'][0] <= index &&
          index <
              widget.format[i]['position'][0] +
                  widget.format[i]['position'][2]) {
        return TextStyle(
            color: Color(
              int.parse(
                      (widget.format[i]['style']['color'] ?? '0xFF000000')
                          .substring(1),
                      radix: 16) +
                  0xFF000000,
            ),
            fontWeight: widget.format[i]['style']['bold']
                ? FontWeight.bold
                : FontWeight.normal,
            fontStyle: widget.format[i]['style']['italic']
                ? FontStyle.italic
                : FontStyle.normal);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.is_sender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (widget.is_sender)
          const Expanded(
            child: SizedBox(width: 50),
          ),
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.color,
          ),
          padding: const EdgeInsets.all(15),
          child: RichText(
            softWrap: true,
            overflow: TextOverflow.visible,
            text: TextSpan(
                style: const TextStyle(fontSize: 20),
                children: List.generate(
                  widget.text.length,
                  (index) => TextSpan(
                    text: widget.text[index],
                    style: TextStyle(
                        backgroundColor: (widget.start_high_light <=
                                    (index + widget.start_index) &&
                                (index + widget.start_index) <=
                                    widget.end_high_light)
                            ? Colors.amber
                            : Colors.transparent,
                        color: check_style(index + widget.start_index)?.color ??
                            const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: check_style(index + widget.start_index)
                                ?.fontWeight ??
                            FontWeight.normal,
                        fontStyle: check_style(index + widget.start_index)
                                ?.fontStyle ??
                            FontStyle.normal),
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
