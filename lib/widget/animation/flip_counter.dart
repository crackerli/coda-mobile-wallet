import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedFlipCounter extends StatelessWidget {
  final int value;
  final Duration duration;
  final double size;
  final Color color;

  const AnimatedFlipCounter({
    Key key,
    @required this.value,
    @required this.duration,
    this.size = 72,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> digits = value == 0 ? [0] : [];

    int v = value;
    if (v < 0) {
      v *= -1;
    }
    while (v > 0) {
      digits.add(v);
      v = v ~/ 10;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(digits.length, (int i) {
        return _SingleDigitFlipCounter(
          key: ValueKey(digits.length - i),
          value: digits[digits.length - i - 1].toDouble(),
          duration: duration,
          height: size,
          width: size / 1.8,
          color: color,
        );
      }),
    );
  }
}

class _SingleDigitFlipCounter extends StatelessWidget {
  final double value;
  final Duration duration;
  final double height;
  final double width;
  final Color color;

  const _SingleDigitFlipCounter({
    Key key,
    @required this.value,
    @required this.duration,
    @required this.height,
    @required this.width,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: value, end: value),
      duration: duration,
      builder: (context, value, child) {
        final whole = value ~/ 1;
        final decimal = value - whole;
        return SizedBox(
          height: height,
          width: width,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildSingleDigit(
                digit: whole % 10,
                offset: height * decimal,
                opacity: 1 - decimal,
              ),
              _buildSingleDigit(
                digit: (whole + 1) % 10,
                offset: height * decimal - height,
                opacity: decimal,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSingleDigit({int digit, double offset, double opacity}) {
    return Positioned(
      child: SizedBox(
        width: width,
        child: Opacity(
          opacity: opacity,
          child: Text(
            "$digit",
            style: TextStyle(fontSize: height, color: color),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      bottom: offset,
    );
  }
}
