import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  const ActionButton(
      {Key? key,
      required this.icon,
      required this.text,
      required this.imageIcon,
      required this.onClick})
      : super(key: key);

  final IconData icon;
  final AssetImage imageIcon;
  final String text;
  final Function onClick;

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  Widget _displayIcon() {
    if (widget.icon != null) {
      return Icon(
        widget.icon,
        size: 23.0,
        color: Colors.blue[800],
      );
    } else if (widget.imageIcon != null) {
      return ImageIcon(
        widget.imageIcon,
        size: 23.0,
        color: Colors.blue[800],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: TextButton(
        onPressed: () {
          widget.onClick();
        },
        child: Column(
          children: <Widget>[
            _displayIcon(),
            Text(
              widget.text,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
