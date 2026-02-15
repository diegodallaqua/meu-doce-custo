import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import '../../../core/global/theme/custom_colors.dart';
import '../../../core/ui/custom_drawer/custom_drawer.dart';
import '../../../core/ui/empty_result.dart';
import '../../../core/ui/error_listing.dart';
import '../../../core/ui/filter_icon_with_badge.dart';
import '../../../core/ui/list_divider.dart';
import '../models/brand.dart';
import '../stores/brand_store.dart';
import '../../../app/shell/stores/filter_search_store.dart';
import 'create_brand_screen.dart';
import 'widgets/filter_visible_brand.dart';
import 'widgets/brand_tile.dart';


class BrandScreen extends StatelessWidget {
  BrandScreen({super.key});

  final brandStore = GetIt.I<BrandStore>();
  final filterStore = GetIt.I<FilterSearchStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.sweet_cream,
        iconTheme: const IconThemeData(color: CustomColors.mint),
        title: const Center(
          child: Text(
            'Marcas',
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
        tooltip: "Cadastrar Nova Marca",
        label: const Text("Nova Marca"),
        heroTag: 'Nova Marca',
        backgroundColor: CustomColors.gay_pink,
        foregroundColor: CustomColors.sweet_cream,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CreateBrandScreen(),
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
          await brandStore.refreshData();
        },
        child: Observer(

          builder: (context) {
            if (brandStore.error != null) {
              return ErrorListing(
                text: brandStore.error!,
                reload: brandStore.refreshData,
              );
            }

            if (brandStore.showProgress) {
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
                  if (filterStore.visibleSearch) ...{FilterVisibleBrand(filterStore: brandStore.filterStore)},
                  if (brandStore.listBrand.isEmpty) ...{
                    Expanded(
                      child: Center(
                        child: EmptyResult(
                          text: 'Nenhuma Marca Encontrada!',
                          reload: brandStore.refreshData,
                        ),
                      ),
                    ),
                  } else ...{
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index < brandStore.listBrand.length) {
                            final brand = brandStore.listBrand[index];
                            return Column(
                              children: [
                                if (index == 0) const ListDivider(),
                                BrandTile(brand: brand),
                                if (index == brandStore.listBrand.length - 1) const ListDivider(),
                              ],
                            );
                          }
                          brandStore.loadNextPage();
                          return Center(
                            child: LinearProgressIndicator(
                              color: CustomColors.gay_pink,
                              backgroundColor: CustomColors.gay_pink.withAlpha(100),
                            ),
                          );
                        },
                        separatorBuilder: (_, index) => const ListDivider(),
                        itemCount: brandStore.itemCount,
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
