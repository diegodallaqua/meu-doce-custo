// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:meu_doce_custo/features/recipies/stores/create_ingredient_used_store.dart';
import 'package:mobx/mobx.dart';

import '../models/ingredient_used.dart';
import '../models/recipe.dart';
import '../repositories/ingredient_used_repository.dart';
import '../models/recipe_category.dart';
import '../repositories/recipe_repository.dart';

/*Comando que precisa executar no terminal:
flutter packages pub run build_runner watch
flutter pub run build_runner watch --delete-conflicting-outputs
dart run build_runner watch -d
*/

part 'create_recipe_store.g.dart';

class CreateRecipeStore = _CreateRecipeStore with _$CreateRecipeStore;

abstract class _CreateRecipeStore with Store {
  _CreateRecipeStore(this.recipe) {
    if (recipe?.id != null) {
      loadIngredientsUsed(recipe!.id!);
    }
    _name = recipe?.name ?? '';
    _recipeCategory = recipe?.recipeCategory;
  }

  late Recipe? recipe;

  @readonly
  String _name = '';

  @action
  void setName(String value) => _name = value;

  @computed
  bool get nameValid => _name.length >= 2;

  String? get nameError {
    if (!showErrors || nameValid) {
      return null;
    } else if (_name.isEmpty) {
      return 'Campo Obrigatório';
    } else if (_name.length < 3) {
      return 'Nome muito curto';
    } else {
      return ('Nome inválido');
    }
  }

  @readonly
  RecipeCategory? _recipeCategory;

  @action
  void setRecipeCategory(RecipeCategory value) => _recipeCategory = value;

  @computed
  bool get recipeCategoryValid => _recipeCategory != null;

  String? get recipeCategoryError {
    if (!showErrors || recipeCategoryValid) {
      return null;
    } else if (!recipeCategoryValid) {
      return 'Campo Obrigatório';
    } else {
      return ('Categoria inválida');
    }
  }

  @observable
  ObservableFuture<List<IngredientUsed>>? ingredientsFuture;

  @readonly
  ObservableList<IngredientUsed>? _selectedIngredients = ObservableList<IngredientUsed>();

  @action
  void addIngredients(List<IngredientUsed> newIngredients) {
    _selectedIngredients!.clear();
    _selectedIngredients!.addAll(newIngredients);
  }

  @computed
  bool get ingredientsValid => _selectedIngredients!.isNotEmpty;

  @computed
  String? get ingredientsError {
    if (!showErrors || ingredientsValid) {
      return null;
    } else {
      return 'Campo obrigatório';
    }
  }

  double _calculateTotalCost() {
    return _selectedIngredients!.fold(0.0, (sum, ingredientUsed) {
      final ingredient = ingredientUsed.ingredient;
      final quantity = ingredientUsed.quantity;

      if (ingredient != null && quantity != null && ingredient.size! > 0) {
        final partialCost = (ingredient.price! * quantity) / ingredient.size!;
        return sum + partialCost;
      }
      return sum;
    });
  }

  @readonly
  bool _savedOrUpdatedOrDeleted = false;

  @action
  void setSavedOrUpdatedOrDeleted(bool value) => _savedOrUpdatedOrDeleted = value;

  @readonly
  bool _loading = false;

  @action
  void setLoading(bool value) => _loading = value;

  @observable
  String? error;

  @action
  void setError(String? value) => error = value;

  @observable
  bool showErrors = false;

  @action
  void invalidSendPressed() => showErrors = true;

  @computed
  bool get isFormValid => nameValid  && recipeCategoryValid && !_loading;

  @computed
  dynamic get createPressed => isFormValid ? _createRecipe : null;

  dynamic get editPressed => isFormValid ? _editRecipe : null;

  Future<void> _createRecipe() async {
    setError(null);
    setLoading(true);

    try {
      recipe = Recipe(
        name: _name,
        cost: _calculateTotalCost(),
        recipeCategory: _recipeCategory!,
      );

      final createdRecipe = await RecipeRepository().createRecipe(recipe!);

      if (createdRecipe == null || createdRecipe.objectId == null) {
        throw Exception('Erro ao criar receita: ID da receita não retornado.');
      }

      // Atualizar o objeto receita com o ID retornado.
      recipe = Recipe(
        id: createdRecipe.objectId,
        name: _name,
        cost: _calculateTotalCost(),
        recipeCategory: _recipeCategory!,
      );

      // Criar os ingredientes com o ID da receita.
      for (final ingredientUsed in _selectedIngredients!) {
        final ingredientUsedStore = CreateIngredientUsedStore(
          ingredientUsed: ingredientUsed,
          recipe: recipe!,
        );
        await ingredientUsedStore.createPressed();
      }

      setSavedOrUpdatedOrDeleted(true);
    } catch (e, s) {
      log('Store: Erro ao Criar Receita!', error: e.toString(), stackTrace: s);
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> _editRecipe() async {
    setError(null);
    setLoading(true);

    try {
      // Atualiza os dados básicos da receita.
      recipe!.name = _name;
      recipe!.recipeCategory = _recipeCategory;

      // Ingredientes selecionados atualmente pelo usuário.
      final updatedIngredients = _selectedIngredients!;

      // Ingredientes já existentes no banco vinculados a essa receita.
      final existingIngredients = await IngredientUsedRepository()
          .getIngredientsUsedByRecipe(recipe!.id!);

      // Novos ingredientes: os que ainda não têm `id` (não estão no banco).
      final newIngredients = updatedIngredients
          .where((ingredientUsed) => ingredientUsed.id == null)
          .toList();

      // Ingredientes removidos: os que existiam no banco, mas foram removidos na interface.
      final removedIngredients = existingIngredients
          .where((existing) =>
      !updatedIngredients.any((updated) => updated.id == existing.id))
          .toList();

      // Atualiza a receita no banco.
      await RecipeRepository().updateRecipe(recipe!);

      // Adiciona novos ingredientes no banco, vinculando o ID da receita.
      for (final ingredientUsed in newIngredients) {
        final ingredientUsedStore = CreateIngredientUsedStore(
          ingredientUsed: ingredientUsed,
          recipe: recipe!,
        );
        await ingredientUsedStore.createPressed();
      }

      // Remove ingredientes deletados
      for (final ingredientUsed in removedIngredients) {
        final ingredientUsedStore = CreateIngredientUsedStore(
          ingredientUsed: ingredientUsed,
          recipe: recipe!,
        );
        await ingredientUsedStore.deleteIngredientUsed();
      }

      // Recalcula o custo total da receita
      final ingredients = await IngredientUsedRepository()
          .getIngredientsUsedByRecipe(recipe!.id!);
      final totalCost = ingredients.fold<num>(
        0.0,
            (sum, ingredient) => sum + (ingredient.parcial_cost ?? 0.0),
      );

      // Atualiza o custo total no banco.
      recipe!.cost = totalCost;
      await RecipeRepository().updateRecipe(recipe!);

      setSavedOrUpdatedOrDeleted(true); // Marca como atualizado.

    } catch (e, s) {
      log('Store: Erro ao Editar Receita!', error: e.toString(), stackTrace: s);
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> deleteRecipe() async {
    setError(null);
    setLoading(true);

    try {
     // Buscar todos os IngredientUsed relacionados à receita
      final ingredients = await IngredientUsedRepository().getIngredientsUsedByRecipe(recipe!.id!);

      // Excluir cada IngredientUsed encontrado
      for (final ingredient in ingredients) {
        await IngredientUsedRepository().deleteIngredientUsed(ingredient.id!);
      }

      // Excluir a receita
      await RecipeRepository().deleteRecipe(recipe!.id!.toString());

      setSavedOrUpdatedOrDeleted(true);
    } catch (e, s) {
      log('Store: Erro ao Deletar Receita!', error: e.toString(), stackTrace: s);
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }


  @action
  Future<void> loadIngredientsUsed(String recipeId) async {
    try {
      final ingredients = await IngredientUsedRepository().getIngredientsUsedByRecipe(recipeId);
      _selectedIngredients!.clear();
      _selectedIngredients!.addAll(ingredients);
      ingredientsFuture = ObservableFuture.value(ingredients);
    } catch (e, s) {
      log('Erro ao carregar IngredientsUsed!', error: e.toString(), stackTrace: s);
      setError(e.toString());
    }
  }

  @action
  Future<void> updateIngredients(List<IngredientUsed> newIngredients) async {
    _selectedIngredients!.clear();
    _selectedIngredients!.addAll(newIngredients);

    for (final ingredient in newIngredients) {
      if (ingredient.id == null) {
        await IngredientUsedRepository().createIngredientUsed(ingredient);
      }
    }
  }
}