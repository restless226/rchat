import 'package:my_chat_app/colors.dart';
import 'package:my_chat_app/theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final Function(String val) onChanged;
  final double height;
  final TextInputAction inputAction;

  const CustomTextField({Key key,
    this.hint,
    this.height = 54.0,
    this.onChanged,
    this.inputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextField(
        style: Theme.of(context).textTheme.caption,
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        textInputAction: inputAction,
        cursorColor: kPrimary,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            hintText: hint,
            border: InputBorder.none),
      ),
      decoration: BoxDecoration(
          color: isLightTheme(context) ? Colors.white : kBubbleDark,
          borderRadius: BorderRadius.circular(45.0),
          border: Border.all(
              color: isLightTheme(context)
                  ? const Color(0xFFC4C4C4)
                  : const Color(0xFF393737),
              width: 1.5)),
    );
  }
}
