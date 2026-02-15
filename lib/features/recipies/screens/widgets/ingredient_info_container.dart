// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../models/ingredient_used.dart';
import '../../../../core/global/theme/custom_colors.dart';

class IngredientInfoContainer extends StatefulWidget {
  const IngredientInfoContainer({
    Key? key,
    required this.ingredientUsed,
    required this.onRemove,
  }) : super(key: key);

  final IngredientUsed ingredientUsed;
  final VoidCallback onRemove;

  @override
  _IngredientInfoContainerState createState() => _IngredientInfoContainerState();
}

class _IngredientInfoContainerState extends State<IngredientInfoContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CustomColors.sweet_cream,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CustomColors.just_regular_brown.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.ingredientUsed.ingredient?.name ?? 'Sem Nome',
                  style: const TextStyle(
                    color: CustomColors.gay_pink,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Marca: ${widget.ingredientUsed.ingredient?.brand?.name ?? 'Sem Marca'}' ,
                  style: const TextStyle(
                    color: CustomColors.mint,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.ingredientUsed.ingredient?.is_ml == 1
                      ? 'Quantidade: ${widget.ingredientUsed.quantity} ml'
                      : 'Quantidade: ${widget.ingredientUsed.quantity} g',
                  style: const TextStyle(
                    color: CustomColors.mint,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: CustomColors.gay_pink),
            onPressed: widget.onRemove,
          ),
        ],
      ),
    );
  }
}
