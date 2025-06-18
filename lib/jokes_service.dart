import 'dart:convert';
import 'package:http/http.dart' as http;

class JokesService {
  Future<List<dynamic>> fetchJokeCategories() async {
    final response = await http.get(
      Uri.parse('https://api.chucknorris.io/jokes/categories'),
    );
    if (response.statusCode == 200) {
      final categories = response.body;
      return jsonDecode(categories);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<Map<String, dynamic>> fetchRandomJoke(String category) async {
    final response = await http.get(
      Uri.parse('https://api.chucknorris.io/jokes/random?category=$category'),
    );
    if (response.statusCode == 200) {
      final jokeData = jsonDecode(response.body);
      return jokeData;
    } else {
      throw Exception('Failed to load joke');
    }
  }

  Future<Map<String, dynamic>> fetchJokeFromHTML(String id) async {
    // mg4dqtopqj-wbduf8rf_mw
    final response = await http.get(
      Uri.parse('https://api.chucknorris.io/jokes/$id'),
    );
    if (response.statusCode == 200) {
      final jokeData = jsonDecode(response.body);
      return jokeData;
    } else {
      throw Exception('Failed to load joke');
    }
  }
}
