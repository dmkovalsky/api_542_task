import 'package:api_542_task/data/database_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository implements DatabaseRepository {
  @override
  Future<void> addJokeId(String id) async {
    // instance of SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    // get the string list 'jokes' from SharedPreferences and add the new id
    prefs.setStringList(
      'jokes',
      [...(prefs.getStringList('jokes') ?? []), id],
    );
  }

  @override
  Future<void> deleteJokeId(int index) async {
    // instance of SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    // get the string list 'jokes' from SharedPreferences
    final jokes = prefs.getStringList('jokes') ?? [];
    // remove the item at the specified index
    jokes.removeAt(index);
    // set the updated list back to SharedPreferences
    await prefs.setStringList('jokes', jokes);
  }

  @override
  Future<List<String>> getJokesIds() async {
    final prefs = await SharedPreferences.getInstance();
    final jokes = prefs.getStringList('jokes') ?? [];
    return jokes;
  }

  @override
  Future<void> clearJokesIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jokes');
  }
}
