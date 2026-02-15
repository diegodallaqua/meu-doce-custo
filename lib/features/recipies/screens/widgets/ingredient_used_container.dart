import 'package:flutter/material.dart';
import '../../../../core/global/theme/custom_colors.dart';
import '../dialogs/dialog_create_ingredient_used.dart';
import '../../models/ingredient_used.dart';
import 'ingredient_info_container.dart';

class IngredientUsedContainer extends StatefulWidget {
  final Function(List<IngredientUsed>) onIngredientsChanged;
  final List<IngredientUsed> initialIngredients;

  const IngredientUsedContainer({
    Key? key,
    required this.onIngredientsChanged,
    this.initialIngredients = const [],
  }) : super(key: key);

  @override
  _IngredientUsedContainerState createState() => _IngredientUsedContainerState();
}

class _IngredientUsedContainerState extends State<IngredientUsedContainer> {
  late List<IngredientUsed> _ingredientsUsed;

  @override
  @override
  void initState() {
    super.initState();
    _ingredientsUsed = List<IngredientUsed>.from(widget.initialIngredients);
  }

  void _addIngredientUsed(IngredientUsed newIngredient) {
    setState(() {
      _ingredientsUsed.add(newIngredient);
    });

    widget.onIngredientsChanged(_ingredientsUsed);
  }

  void _removeIngredientUsed(IngredientUsed ingredient) {
    setState(() {
      _ingredientsUsed.remove(ingredient);
    });

    widget.onIngredientsChanged(_ingredientsUsed);
  }

  Future<void> showCreateIngredientDialog() async {
    final newIngredient = await showDialog<IngredientUsed>(
      context: context,
      builder: (BuildContext context) {
        return const DialogCreateIngredientUsed();
      },
    );

    if (newIngredient != null) {
      _addIngredientUsed(newIngredient);
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: CustomColors.mint,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: CustomColors.just_regular_brown.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(minHeight: 250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Ingredientes Utilizados',
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.sweet_cream,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_ingredientsUsed.isNotEmpty)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _ingredientsUsed.map((ingredient) {
                    return IngredientInfoContainer(
                      ingredientUsed: ingredient,
                      onRemove: () => _removeIngredientUsed(ingredient),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: showCreateIngredientDialog,
            backgroundColor: CustomColors.sweet_cream,
            child: const Icon(Icons.add, size: 40, color: CustomColors.mint),
          ),
        ),
      ],
    );
  }
}

