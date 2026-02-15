import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meu_doce_custo/features/recipies/stores/create_ingredient_used_store.dart';
import '../../models/ingredient_used.dart';
import '../../../../core/global/theme/custom_colors.dart';
import '../../../../core/ui/custom_field.dart';
import '../../../../core/ui/custom_form_field.dart';
import '../../../../core/ui/patterned_buttom.dart';
import '../../../ingredient/screens/dialogs/dialog_ingredient.dart';

class DialogCreateIngredientUsed extends StatefulWidget {
  const DialogCreateIngredientUsed({
    Key? key,
    this.ingredientUsed,
  }) : super(key: key);

  final IngredientUsed? ingredientUsed;

  @override
  _DialogCreateIngredientUsedState createState() => _DialogCreateIngredientUsedState();
}

class _DialogCreateIngredientUsedState extends State<DialogCreateIngredientUsed> {
  late final CreateIngredientUsedStore createIngredientUsedStore;

  @override
  void initState() {
    super.initState();
    createIngredientUsedStore = CreateIngredientUsedStore(ingredientUsed: widget.ingredientUsed);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: CustomColors.sweet_cream,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: CustomColors.mint),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Novo Ingrediente',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: CustomColors.mint,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Observer(
                    builder: (context) => CustomField(
                      onTap: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (context) => DialogIngredient(
                            selectedIngredient: createIngredientUsedStore.ingredient,
                          ),
                        );
                        if (result != null) {
                          createIngredientUsedStore.setIngredient(result);
                        }
                      },
                      title: createIngredientUsedStore.ingredient?.name ?? "Selecione o Ingrediente",
                      borderColor: createIngredientUsedStore.ingredientError != null
                          ? Colors.red.shade700
                          : CustomColors.mint.withAlpha(50),
                      error: createIngredientUsedStore.ingredientError,
                      clearOnPressed: null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Observer(
                    builder: (context) => CustomFormField(
                      typeKeyboard: TextInputType.number,
                      suffixText: createIngredientUsedStore.ingredient?.is_ml == true ? 'ml' : 'g',
                      input: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      initialvalue: createIngredientUsedStore.quantity,
                      onChanged: createIngredientUsedStore.setQuantity,
                      textInputAction: TextInputAction.next,
                      error: createIngredientUsedStore.quantityError,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Observer(
                  builder: (context) => GestureDetector(
                    onTap: () => createIngredientUsedStore.invalidSendPressed(),
                    child: PatternedButton(
                      color: CustomColors.gay_pink,
                      text: 'Salvar',
                      largura: 90,
                      function: createIngredientUsedStore.isFormValid ? () {
                        final ingredientUsed = IngredientUsed(
                          ingredient: createIngredientUsedStore.ingredient,
                          quantity: int.parse(createIngredientUsedStore.quantity),
                        );
                        Navigator.of(context).pop(
                          IngredientUsed(
                            ingredient: createIngredientUsedStore.ingredient,
                            quantity: int.parse(createIngredientUsedStore.quantity),
                          ),
                        );
                      } : null,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


