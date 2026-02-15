import 'package:flutter/material.dart';

import '../global/theme/custom_colors.dart';

class ErrorListing extends StatelessWidget {
  const ErrorListing({
    super.key,
    required this.text,
    required this.reload,
  });

  final String text;
  final VoidCallback reload;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.grey,
            size: 50,
          ),
          const SizedBox(height: 8),
          Text(
            'Ocorreu um erro: $text',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: reload,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: CustomColors.gay_pink,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text(
                  'Tentar Novamente',
                  style: TextStyle(
                    color: CustomColors.sweet_cream,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
