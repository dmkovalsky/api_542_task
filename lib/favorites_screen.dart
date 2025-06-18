import 'package:api_542_task/data/database_repository.dart';
import 'package:api_542_task/jokes_service.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  final DatabaseRepository localDB;

  const FavoritesScreen(this.localDB, {super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // State
  Future<List<String>>? _favoriteIds;

  //final Future<Map<String, dynamic>> _favoritesFuture = JokesService()
  //.fetchJokeFromHTML('mg4dqtopqj-wbduf8rf_mw');

  @override
  void initState() {
    super.initState();
    _favoriteIds = _loadFavoritesIds();
  }

  Future<List<String>> _loadFavoritesIds() async {
    List<String> jokesIds = await widget.localDB.getJokesIds();
    if (jokesIds.isEmpty) {
      return [];
    }
    return jokesIds;
  }

  Future<Map<String, dynamic>> _loadFavoriteJoke(String id) async {
    try {
      return await JokesService().fetchJokeFromHTML(id);
    } catch (e) {
      throw Exception('Failed to load joke with id $id: $e');
    }
  }

  void deleteFavorites() async {
    await widget.localDB.clearJokesIds();
    setState(() {
      _favoriteIds = _loadFavoritesIds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: Image.network(
                  'https://api.chucknorris.io/img/chucknorris_logo_coloured_small.png',
                  width: 300,
                ),
              ),
              SizedBox(height: 32),
              FutureBuilder(
                future: _favoriteIds,
                builder: (context, snapshoot) {
                  if (snapshoot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshoot.hasError) {
                    return Center(child: Text('Error: ${snapshoot.error}'));
                  }
                  final favoriteIds = snapshoot.data;
                  if (favoriteIds == null || favoriteIds.isEmpty) {
                    return Center(child: Text('No favorites yet!'));
                  }
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: favoriteIds.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                          future: _loadFavoriteJoke(favoriteIds[index]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListTile(
                                title: Text('Loading...'),
                              );
                            }
                            if (snapshot.hasError) {
                              return ListTile(
                                title: Text('Error: ${snapshot.error}'),
                              );
                            }
                            final joke = snapshot.data;
                            if (joke == null) {
                              return ListTile(
                                title: Text('No joke found'),
                              );
                            }
                            return ListTile(
                              title: Text(joke['value'] ?? 'No joke text'),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  deleteFavorites();
                },
                child: Text('Clear Favorites'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
