abstract class DatabaseRepository {
  // Gibt die Jokes IDs zurück.
  Future<List<String>> getJokesIds();

  // Fügt ein neues Joke ID hinzu.
  Future<void> addJokeId(String id);

  // Löscht ein Joke ID an einem bestimmten Index.
  Future<void> deleteJokeId(int index);

  // Löscht alle Ids: clearJokesIds
  Future<void> clearJokesIds();
}
