import 'package:flutter/material.dart';

import '../global/theme/custom_colors.dart';

class PasswordDivider extends StatelessWidget {
  const PasswordDivider({super.key});

  @override
  Widget build(BuildContext context) {
    const thickness = 0.75;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: const Row(
        children: [
          Expanded(
            child: Divider(
              color: CustomColors.gay_pink,
              thickness: thickness,
              height: 0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Senha',
              style: TextStyle(
                color: CustomColors.gay_pink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: CustomColors.gay_pink,
              thickness: thickness,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }
}