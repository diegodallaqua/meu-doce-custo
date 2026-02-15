import 'package:flutter/material.dart';
import '../global/theme/custom_colors.dart';

class EmptyResult extends StatelessWidget {
  const EmptyResult({
    super.key,
    required this.text,
    required this.reload,
  });

  final String text;
  final VoidCallback reload;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Icon(
              Icons.playlist_remove,
              color: CustomColors.mint,
              size: 50,
            ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CustomColors.mint,
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
                    'Buscar Novamente',
                    style: TextStyle(
                      color: CustomColors.sweet_cream,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
