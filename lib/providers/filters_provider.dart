import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals2_app/providers/meals_provider.dart';
//import 'package:meals2_app/screens/filters.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeMeals = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (activeMeals[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeMeals[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeMeals[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeMeals[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
