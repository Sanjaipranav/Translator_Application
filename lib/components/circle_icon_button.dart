import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final double size;
  final VoidCallback onPressed;
  final IconData icon;

  const CircleIconButton(
      {super.key, this.size = 30.0, this.icon = Icons.clear, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: const Alignment(0.0, 0.0), // all centered
          children: <Widget>[
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey[300]),
            ),
            Icon(
              icon,
              size: size * 0.6, // 60% width for icon
            )
          ],
        ),
      ),
    );
  }
}
