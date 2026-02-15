import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import '../../../core/global/theme/custom_colors.dart';
import '../../../core/ui/custom_drawer/custom_drawer.dart';
import '../../../core/ui/empty_result.dart';
import '../../../core/ui/error_listing.dart';
import '../../../core/ui/filter_icon_with_badge.dart';
import '../../../core/ui/list_divider.dart';
import '../stores/ingredient_store.dart';
import '../../../app/shell/stores/filter_search_store.dart';
import 'create_ingredient_screen.dart';
import 'widgets/filter_visible_ingredient.dart';
import 'widgets/ingredient_tile.dart';


class IngredientScreen extends StatelessWidget {
  IngredientScreen({super.key});

  final ingredientStore = GetIt.I<IngredientStore>();
  final filterStore = GetIt.I<FilterSearchStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.sweet_cream,
        iconTheme: const IconThemeData(color: CustomColors.mint),
        title: const Center(
          child: Text(
            'Ingredientes',
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
        tooltip: "Cadastrar Novo Ingrediente",
        label: const Text("Novo Ingrediente"),
        heroTag: 'Novo Ingrediente',
        backgroundColor: CustomColors.gay_pink,
        foregroundColor: CustomColors.sweet_cream,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CreateIngredientScreen(),
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
          await ingredientStore.refreshData();
        },
        child: Observer(

          builder: (context) {
            if (ingredientStore.error != null) {
              return ErrorListing(
                text: ingredientStore.error!,
                reload: ingredientStore.refreshData,
              );
            }

            if (ingredientStore.showProgress) {
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
                  if (filterStore.visibleSearch) ...{FilterVisibleIngredient(filterStore: ingredientStore.filterStore)},
                  if (ingredientStore.listIngredient.isEmpty) ...{
                    Expanded(
                      child: Center(
                        child: EmptyResult(
                          text: 'Nenhum Ingrediente Encontrado!',
                          reload: ingredientStore.refreshData,
                        ),
                      ),
                    ),
                  } else ...{
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index < ingredientStore.listIngredient.length) {
                            final ingredient = ingredientStore.listIngredient[index];
                            return Column(
                              children: [
                                if (index == 0) const ListDivider(),
                                IngredientTile(ingredient: ingredient),
                                if (index == ingredientStore.listIngredient.length - 1) const ListDivider(),
                              ],
                            );
                          }
                          ingredientStore.loadNextPage();
                          return Center(
                            child: LinearProgressIndicator(
                              color: CustomColors.gay_pink,
                              backgroundColor: CustomColors.gay_pink.withAlpha(100),
                            ),
                          );
                        },
                        separatorBuilder: (_, index) => const ListDivider(),
                        itemCount: ingredientStore.itemCount,
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
