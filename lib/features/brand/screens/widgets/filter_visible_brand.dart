import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/global/theme/custom_colors.dart';
import '../../stores/brand_store.dart';
import '../../../../app/shell/stores/filter_search_store.dart';

class FilterVisibleBrand extends StatefulWidget {
  const FilterVisibleBrand({super.key, required this.filterStore});

  final FilterSearchStore filterStore;

  @override
  State<FilterVisibleBrand> createState() => _FilterVisibleBrandState();
}

class _FilterVisibleBrandState extends State<FilterVisibleBrand> {
  //recebe uma copia do filtro que esta na HomeStore
  final FilterSearchStore filterStoreGet = GetIt.I<FilterSearchStore>();

  final BrandStore brandStore = GetIt.I<BrandStore>();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pesquise pelo Nome da Marca',
              style: TextStyle(
                color: CustomColors.gay_pink,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Observer(
              builder: (context) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  child: TextFormField(
                    cursorColor: CustomColors.gay_pink,
                    keyboardType: TextInputType.text,
                    initialValue: widget.filterStore.search,
                    onChanged: widget.filterStore.setSearch,
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: CustomColors.gay_pink,
                            width: 1,
                          )),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: CustomColors.gay_pink,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusColor: CustomColors.gay_pink,
                      errorText: null,
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.text_fields_rounded,
                          color: CustomColors.gay_pink,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            //BOTAO LIMPAR
            Observer(builder: (_) {
              if (widget.filterStore.isFilterCount) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        backgroundColor: CustomColors.sweet_cream,
                      ),
                      onPressed: () async {
                        filterStoreGet.clearFilters();
                        widget.filterStore.clearFilters();
                        brandStore.setFilter(widget.filterStore);
                        filterStoreGet.setVisibleSearchFalse();

                      },
                      child: Text(
                        'Limpar filtros',
                        style: TextStyle(
                          //fontFamily: ,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: CustomColors.gay_pink,

                          shadows: [
                            Shadow(
                              color: Colors.grey.withOpacity(0.5), // Cor da sombra
                              offset: const Offset(0, 2), // Deslocamento da sombra (x, y)
                              blurRadius: 4, // O quão embaçada é a sombra
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }),

            const SizedBox(height: 5),

            //BOTAO
            Observer(builder: (_) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      backgroundColor: CustomColors.gay_pink,
                    ),
                    onPressed: widget.filterStore.isFormValid ? () async {
                      filterStoreGet.setVisibleSearchFalse();
                      brandStore.setFilter(widget.filterStore);
                    } : null,
                    child: Text(
                      'Aplicar filtros',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: CustomColors.sweet_cream,
                        shadows: [
                          Shadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      );
    });
  }
}
