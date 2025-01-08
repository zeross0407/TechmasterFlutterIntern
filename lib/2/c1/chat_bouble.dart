import 'package:fluter_intern_tech_master/2/optimize/optimize.dart';

import 'package:flutter/material.dart';

class Chat_Bouble extends StatefulWidget {
  Line_data line_data;
  Chat_Bouble({super.key, required this.line_data});

  @override
  State<Chat_Bouble> createState() => _Chat_BoubleState();
}

class _Chat_BoubleState extends State<Chat_Bouble> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.line_data.speaker)
          const Expanded(
            child: SizedBox(width: 50),
          ),
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width *
                  0.7), // Giới hạn chiều rộng của Container
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.line_data.bouble_color,
          ),
          padding: const EdgeInsets.all(15),
          child: RichText(
            softWrap: true, // Cho phép xuống dòng khi hết chỗ
            overflow: TextOverflow.visible, // Đảm bảo không bị cắt bớt văn bản
            text: TextSpan(
                style: TextStyle(fontSize: 20),
                children: List.generate(
                      widget.line_data.words_data.length,
                      (index) => TextSpan(
                          text: widget.line_data.words_data[index].text +
                              ((widget.line_data.words_data[index].length >
                                      widget.line_data.words_data[index].text
                                          .length)
                                  ? " " *
                                      ((widget.line_data.words_data[index].length -
                                          widget.line_data.words_data[index]
                                              .text.length))
                                  : ''), // Đoạn văn bản có thể nhấn
                          style: TextStyle(
                              backgroundColor:
                                  widget.line_data.words_data[index].hight_lighting
                                      ? Colors.amber
                                      : Colors.transparent,
                              color: widget.line_data.words_data[index].textStyle?.color ??
                                  Colors.black,
                              fontWeight: widget.line_data.words_data[index]
                                      .textStyle?.fontWeight ??
                                  FontWeight.normal,
                              fontStyle: widget.line_data.words_data[index].textStyle?.fontStyle ??
                                  FontStyle.normal,
                              decoration: widget.line_data.words_data[index].textStyle?.decoration ?? TextDecoration.none)),
                    ) +
                    []),
          ),
        ),
      ],
    );
  }
}
