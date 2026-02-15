import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/global/theme/custom_colors.dart';
import '../../models/ingredient.dart';
import '../create_ingredient_screen.dart';

class IngredientTile extends StatelessWidget {
  const IngredientTile({Key? key, required this.ingredient}) : super(key: key);

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: CupertinoListTile(
        padding: const EdgeInsets.symmetric(vertical: 8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              ingredient.name!,
              style: TextStyle(
                color: CustomColors.just_regular_brown.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              ingredient.is_ml == 1 ? 'Tamanho: ${ingredient.size}ml' : 'Tamanho: ${ingredient.size}g',
              style: TextStyle(
                color: CustomColors.just_regular_brown.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              'Marca: ${ingredient.brand!.name}',
              style: TextStyle(
                color: CustomColors.just_regular_brown.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              'Preço: R\$${ingredient.price!.toStringAsFixed(2)}',
              style: TextStyle(
                color: CustomColors.just_regular_brown.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateIngredientScreen(ingredient: ingredient),
                )
            );
          },
          icon: Icon(
            Icons.edit,
            color: CustomColors.just_regular_brown.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
