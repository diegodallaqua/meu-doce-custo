import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../models/recipe_category.dart';
import '../../stores/recipe_category_store.dart';
import '../../../../core/global/theme/custom_colors.dart';
import '../../../../core/ui/empty_result.dart';

class DialogRecipeCategory extends StatelessWidget {
  DialogRecipeCategory({Key? key, this.selectedRecipeCategory}) : super(key: key);

  final recipeCategoryStore = GetIt.I<RecipeCategoryStore>();
  final RecipeCategory? selectedRecipeCategory;

  final divider = const Divider(height: 0);

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
                    'Selecione a Categoria',
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
                    onChanged: (value) => recipeCategoryStore.runFilter(value),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.search,
                        color: CustomColors.mint,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          Observer(
            builder: (context) {
              if (recipeCategoryStore.loading) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: CustomColors.mint,
                    ),
                  ),
                );
              }

              if (recipeCategoryStore.listCategory.isEmpty) {
                return Expanded(
                  child: Center(
                    child: EmptyResult(
                      text: 'Nenhuma Categoria Encontrada!',
                      reload: recipeCategoryStore.refreshData,
                    ),
                  ),
                );
              }

              final uniqueCategories = recipeCategoryStore.listSearch.toSet().toList();
              final seenIds = <String>{};
              final filteredList = uniqueCategories.where((category) {
                final isUnique = seenIds.add(category.id!.toString());
                return isUnique;
              }).toList();

              return Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final recipeCategory = filteredList[index];

                    return InkWell(
                      onTap: () => Navigator.of(context).pop(recipeCategory),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: recipeCategory.id == selectedRecipeCategory?.id
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
                          recipeCategory.name!,
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
          )
        ],
      ),
    );
  }
}
