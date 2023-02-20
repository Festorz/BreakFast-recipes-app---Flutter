import 'dart:convert';

class MealsModel {
  int id;
  String title;
  String image;
  int readyInMinutes;
  int servings;

  MealsModel({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.servings,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
    };
  }

  factory MealsModel.fromJson(Map<String, dynamic> map) {
    return MealsModel(
      title: map['title'],
      image: map['image'],
      readyInMinutes: map['readyInMinutes'],
      id: map["id"],
      servings: map["servings"],
    );
  }

  // String toJson() => json.encode(toMap());

  // factory MealsModel.fromJson(String source) => MealsModel.fromMap(json.decode(source));
}
