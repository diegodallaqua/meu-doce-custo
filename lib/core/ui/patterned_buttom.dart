import 'package:flutter/material.dart';

import '../global/theme/custom_colors.dart';

class PatternedButton extends StatelessWidget {
  const PatternedButton({
    super.key,
    required this.largura,
    required this.color,
    required this.text,
    required this.function,
    this.textColor,
    this.borderRadius
  });

  final double? largura;
  final Color color;
  final Color? textColor;
  final String text;
  final Function()? function;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: largura,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 24),
            ),
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            elevation: 8,
            shadowColor: CustomColors.just_regular_brown
        ),

        onPressed: function,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 17,
              color: textColor ?? CustomColors.sweet_cream),
        ),
      ),
    );
  }
}
