import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meu_doce_custo/features/ingredient/screens/ingredient_screen.dart';
import 'package:meu_doce_custo/features/recipies/screens/recipe_screen.dart';
import 'package:mobx/mobx.dart';
import '../../core/global/theme/custom_colors.dart';
import '../../core/ui/custom_drawer/custom_drawer.dart';
import 'stores/page_store.dart';
import '../../features/brand/screens/brand_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();
  final PageStore pageStore = GetIt.I<PageStore>();

  @override
  void initState() {
    super.initState();

    reaction<int>((_) => pageStore.page, (page) {
      pageController.jumpToPage(page);
      setState(() {});
    });
  }

  // Página de teste
  Widget TestPage({required String title}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.sweet_cream,
        title: Text(title, style: const TextStyle(color: CustomColors.mint)),
        iconTheme: const IconThemeData(color: CustomColors.mint),
      ),
      drawer: CustomDrawer(),
      backgroundColor: CustomColors.sweet_cream,
      body: const Center(
        child: Text('Página de Teste', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            RecipeScreen(),
            IngredientScreen(),
            BrandScreen(),
          ],
        ),
      ),
    );
  }
}
