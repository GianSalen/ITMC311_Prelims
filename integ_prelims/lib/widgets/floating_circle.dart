import 'package:flutter/material.dart';
import 'dart:math';


class FloatingCircle extends StatelessWidget {
  final AnimationController controller;
  final double size;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final int delay;

  const FloatingCircle({
    required this.controller,
    required this.size,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.delay = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final progress =
            ((controller.value + (delay / 15)) % 1.0);
        final angle = 2 * pi * progress;
        final dx = cos(angle) * 20;
        final dy = sin(angle) * 20;
        return Positioned(
          top: top != null
              ? MediaQuery.of(context).size.height * top! + dy
              : null,
          bottom: bottom != null
              ? MediaQuery.of(context).size.height * bottom! + dy
              : null,
          left: left != null
              ? MediaQuery.of(context).size.width * left! + dx
              : null,
          right: right != null
              ? MediaQuery.of(context).size.width * right! + dx
              : null,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}