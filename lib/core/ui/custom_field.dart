import 'package:flutter/material.dart';

import '../global/theme/custom_colors.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    Key? key,
    required this.onTap,
    this.clearOnPressed,
    required this.borderColor,
    required this.title,
    this.error,
  }) : super(key: key);

  final VoidCallback onTap;
  final VoidCallback? clearOnPressed;
  final Color borderColor;
  final String title;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 63,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: CustomColors.mint.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              //contentPadding: const EdgeInsets.symmetric(horizontal: 5),
              title: Text(
                title,
                style: const TextStyle(
                    color: CustomColors.just_regular_brown
                ),
              ),
              trailing: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ),
          ),
        ),
        if (error != null)
          Container(
            padding: const EdgeInsets.fromLTRB(2, 7, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              error!,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
