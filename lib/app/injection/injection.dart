// ignore_for_file: non_constant_identifier_names

import 'package:get_it/get_it.dart';

import '../../features/brand/stores/brand_store.dart';
import '../../features/ingredient/stores/ingredient_store.dart';
import '../../features/recipies/stores/recipe_category_store.dart';
import '../../features/recipies/stores/recipe_store.dart';
import '../shell/stores/filter_search_store.dart';
import '../../features/auth/stores/login_store.dart';
import '../shell/stores/page_store.dart';
import '../../features/user/stores/user_manager_store.dart';

void ConfigureDependencies() {
  GetIt.I.registerSingleton(UserManagerStore());
  GetIt.I.registerSingleton(LoginStore());
  GetIt.I.registerSingleton(PageStore());
  GetIt.I.registerSingleton(FilterSearchStore());
  GetIt.I.registerSingleton(BrandStore());
  GetIt.I.registerSingleton(IngredientStore());
  GetIt.I.registerSingleton(RecipeStore());
  GetIt.I.registerSingleton(RecipeCategoryStore());
}
