import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import '../../../core/global/theme/custom_colors.dart';
import '../../../core/ui/custom_drawer/custom_drawer.dart';
import '../../../core/ui/empty_result.dart';
import '../../../core/ui/error_listing.dart';
import '../../../core/ui/filter_icon_with_badge.dart';
import '../../../core/ui/list_divider.dart';
import '../stores/recipe_store.dart';
import '../../../app/shell/stores/filter_search_store.dart';
import 'create_recipe_screen.dart';
import 'widgets/filter_visible_recipe.dart';
import 'widgets/recipe_tile.dart';


class RecipeScreen extends StatelessWidget {
  RecipeScreen({super.key});

  final recipeStore = GetIt.I<RecipeStore>();
  final filterStore = GetIt.I<FilterSearchStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.sweet_cream,
        iconTheme: const IconThemeData(color: CustomColors.mint),
        title: const Center(
          child: Text(
            'Receitas',
            style: TextStyle(
              color: CustomColors.mint,
            ),
          ),
        ),
        actions: [
          Observer(
            builder: (_) {
              return FilterIconWithBadge(
                ontap: () {
                  filterStore.setVisibleSearch();
                },
                number: filterStore.getCountFilter,
              );
            },
          ),
        ],
      ),
      backgroundColor: CustomColors.sweet_cream,
      drawer: CustomDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: "Cadastrar Nova Receita",
        label: const Text("Nova Receita"),
        heroTag: 'Nova Receita',
        backgroundColor: CustomColors.gay_pink,
        foregroundColor: CustomColors.sweet_cream,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CreateRecipeScreen(),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      body: RefreshIndicator(
        color: CustomColors.gay_pink,
        onRefresh: () async {
          await recipeStore.refreshData();
        },
        child: Observer(

          builder: (context) {
            if (recipeStore.error != null) {
              return ErrorListing(
                text: recipeStore.error!,
                reload: recipeStore.refreshData,
              );
            }

            if (recipeStore.showProgress) {
              return const Center(
                child: CircularProgressIndicator(
                  color: CustomColors.gay_pink,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  if (filterStore.visibleSearch) ...{FilterVisibleRecipe(filterStore: recipeStore.filterStore)},
                  if (recipeStore.listRecipe.isEmpty) ...{
                    Expanded(
                      child: Center(
                        child: EmptyResult(
                          text: 'Nenhuma Receita Encontrada!',
                          reload: recipeStore.refreshData,
                        ),
                      ),
                    ),
                  } else ...{
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index < recipeStore.listRecipe.length) {
                            final recipe = recipeStore.listRecipe[index];
                            return Column(
                              children: [
                                if (index == 0) const ListDivider(),
                                RecipeTile(recipe: recipe),
                              ],
                            );
                          }
                          recipeStore.loadNextPage();
                          return Center(
                            child: LinearProgressIndicator(
                              color: CustomColors.gay_pink,
                              backgroundColor: CustomColors.gay_pink.withAlpha(100),
                            ),
                          );
                        },
                        itemCount: recipeStore.itemCount,
                      ),
                    ),
                  },
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
