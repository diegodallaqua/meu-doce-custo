import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:meu_doce_custo/features/brand/models/brand.dart';

import '../../stores/brand_store.dart';
import '../../../../core/global/theme/custom_colors.dart';
import '../../../../core/ui/empty_result.dart';

class DialogBrand extends StatelessWidget {
  DialogBrand({Key? key, this.selectedBrand}) : super(key: key);

  final brandStore = GetIt.I<BrandStore>();
  final Brand? selectedBrand;

  final divider = const Divider(height: 0);
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (brandStore.listBrand.isEmpty) {
      brandStore.refreshData();
    }

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
                    'Selecione a Marca',
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
                    onChanged: (value) => brandStore.runFilter(value),
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
                              brandStore.runFilter(searchController.text);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: CustomColors.mint,
                            ),
                            onPressed: () {
                              searchController.clear();
                              brandStore.runFilter('');
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
              if (brandStore.loading) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: CustomColors.mint,
                    ),
                  ),
                );
              }

              if (brandStore.listBrand.isEmpty) {
                return Expanded(
                  child: Center(
                    child: EmptyResult(
                      text: 'Nenhuma Marca Encontrada!',
                      reload: brandStore.refreshData,
                    ),
                  ),
                );
              }

              final uniqueList = brandStore.listSearch.fold<Map<String, Brand>>({}, (map, brand) {
                map[brand.id!] = brand;
                return map;
              }).values.toList();

              return Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final brand = uniqueList[index];

                    return InkWell(
                      onTap: () => Navigator.of(context).pop(brand),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: brand.id == selectedBrand?.id
                              ? CustomColors.mint.withAlpha(50)
                              : null,
                          border: uniqueList.length - 1 == index
                              ? Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                          )
                              : null,
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          brand.name!,
                          style: const TextStyle(
                            color: CustomColors.just_regular_brown,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => divider,
                  itemCount: uniqueList.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
