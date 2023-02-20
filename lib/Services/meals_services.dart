import 'dart:convert';

import 'package:breakfast_recipes/model/meals.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MealServices {
  Client client = http.Client();
  var baseUrl = Uri.parse(
      "https://api.spoonacular.com/recipes/search?query=breakfast&number=10&instructionsRequired=true&apiKey=1bbf561e28c94ad3bba19d5d5cbbba94");
  Future<List<MealsModel>> getMeals() async {
    var result = await client.get(baseUrl);
    try {
      if (result.statusCode == 200) {
        List<dynamic> list = json.decode(result.body);
        return list.map((e) => MealsModel.fromJson(e)).toList();
      } else {
        return <MealsModel>[];
      }
    } catch (e) {
      print(e);
      return <MealsModel>[];
    }
  }
}
