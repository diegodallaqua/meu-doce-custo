import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../models/ingredient.dart';
import '../../stores/ingredient_store.dart';
import '../../../../core/global/theme/custom_colors.dart';
import '../../../../core/ui/empty_result.dart';

class DialogIngredient extends StatelessWidget {
  DialogIngredient({Key? key, this.selectedIngredient}) : super(key: key);

  final ingredientStore = GetIt.I<IngredientStore>();
  final Ingredient? selectedIngredient;

  final divider = const Divider(height: 0);
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Selecione o Ingrediente',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.mint,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 25,
                      color: CustomColors.mint,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
          divider,
          Observer(builder: (_) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Container(
                height: 63,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: CustomColors.mint,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => ingredientStore.runFilter(value),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: CustomColors.mint,
                            ),
                            onPressed: () {
                              ingredientStore.runFilter(searchController.text);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: CustomColors.mint,
                            ),
                            onPressed: () {
                              searchController.clear();
                              ingredientStore.runFilter('');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          Observer(
            builder: (context) {
              if (ingredientStore.loading) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: CustomColors.mint,
                    ),
                  ),
                );
              }

              if (ingredientStore.listIngredient.isEmpty) {
                return Expanded(
                  child: Center(
                    child: EmptyResult(
                      text: 'Nenhum Ingrediente Encontrado!',
                      reload: ingredientStore.refreshData,
                    ),
                  ),
                );
              }

              final uniqueIngredients = ingredientStore.listSearch.toSet().toList();
              final seenIds = <String>{};
              final filteredList = uniqueIngredients.where((ingredient) {
                final isUnique = seenIds.add(ingredient.id!.toString());
                return isUnique;
              }).toList();

              return Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final ingredient = filteredList[index];

                    return InkWell(
                      onTap: () => Navigator.of(context).pop(ingredient),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: ingredient.id == selectedIngredient?.id
                              ? CustomColors.mint.withAlpha(50)
                              : null,
                          border: filteredList.length - 1 == index
                              ? Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                          )
                              : null,
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          ingredient.name!,
                          style: const TextStyle(
                            color: CustomColors.just_regular_brown,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => divider,
                  itemCount: filteredList.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
