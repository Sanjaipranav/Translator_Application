import 'dart:async';

import 'package:flutter/material.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({super.key, 
    required this.leftWidget,
    required this.rightWidget,
    required this.onClick,
    required this.isActive,
  });

  final bool isActive;
  final Widget leftWidget;
  final Widget rightWidget;
  final Function(bool) onClick;

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late Animation<double> _animation2;
  late AnimationController _controller;
  late AnimationController _controller2;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _controller2 =
            AnimationController(vsync: this, duration: const Duration(seconds: 2))
              ..repeat();
        _animation2 =
            CurvedAnimation(parent: _controller2, curve: Curves.linear);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  Widget _buttonWave(Animation<double> animation) {
    return Center(
      child: ScaleTransition(
        scale: animation,
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 3,
              color: Colors.red,
              style: BorderStyle.solid,
            ),
          ),
          height: 140,
          width: 140,
        ),
      ),
    );
  }

  Widget _displaysButtonWave2() {
    if (widget.isActive) {
      return _buttonWave(_animation2);
    } else {
      return const SizedBox(
        height: 140,
        width: 140,
      );
    }
  }

  Widget _displaysButtonWave1() {
    if (widget.isActive) {
      return _buttonWave(_animation);
    } else {
      return const SizedBox(
        height: 140,
        width: 140,
      );
    }
  }

  Widget _displaysRecordingButton() {
    return Container(
      margin: const EdgeInsets.only(top: 35),
      child: ButtonTheme(
        minWidth: 70.0,
        height: 70.0,
        child: ElevatedButton(
          onPressed: () {
            widget.onClick(widget.isActive);
          },
          child: const Icon(
            Icons.mic,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _displaysButtonWave1(),
        _displaysButtonWave2(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            widget.leftWidget ?? Expanded(
                    child: Container(),
                  ),
            _displaysRecordingButton(),
            widget.rightWidget ?? Expanded(
                    child: Container(),
                  ),
          ],
        ),
      ],
    );
  }
}
