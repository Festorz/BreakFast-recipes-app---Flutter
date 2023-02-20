import 'dart:convert';
import 'dart:ffi';

class RecipeModel {
  String title;
  var image;
  String instructions;
  int servings;
  int readyInMinutes;
  bool vegetarian;
  bool veryHealthy;
  List<dynamic> extendedIngredients = [];

  RecipeModel({
    required this.title,
    required this.image,
    required this.instructions,
    required this.servings,
    required this.readyInMinutes,
    required this.vegetarian,
    required this.veryHealthy,
    required this.extendedIngredients,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'instructions': instructions,
      'servings': servings,
      'readyInMinutes': readyInMinutes,
    };
  }

  factory RecipeModel.fromJson(Map<String, dynamic> map) {
    return RecipeModel(
      title: map['title'],
      image: map['image'],
      instructions: map['instructions'],
      servings: map['servings'],
      readyInMinutes: map['readyInMinutes'],
      veryHealthy: map['veryHealthy'],
      vegetarian: map['vegetarian'],
      extendedIngredients: map['extendedIngredients'],
    );
  }
}
