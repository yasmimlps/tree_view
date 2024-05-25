import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonCheck extends StatefulWidget {
  final String text;
  final String iconPath;
  final bool initialValue;
  final void Function(bool) onChanged;

  ButtonCheck({
    required this.text,
    required this.iconPath,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  _CustomCheckboxButtonState createState() => _CustomCheckboxButtonState();
}

class _CustomCheckboxButtonState extends State<ButtonCheck> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: _isChecked ? Colors.blue : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.0),
          side: BorderSide(color: Color.fromRGBO(216, 223, 230, 1)),
        ),
      ),
      onPressed: () {
        setState(() {
          _isChecked = !_isChecked;
          widget.onChanged(_isChecked);
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            widget.iconPath,
            width: 21,
            height: 16,
            color: _isChecked ? Colors.white : Color.fromRGBO(119, 129, 140, 1),
          ),
          SizedBox(width: 8),
          Text(
            widget.text,
            style: TextStyle(
                color: _isChecked
                    ? Colors.white
                    : Color.fromRGBO(119, 129, 140, 1),
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
