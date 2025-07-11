import 'package:api_542_task/data/database_repository.dart';
import 'package:api_542_task/favorites_screen.dart';
import 'package:api_542_task/jokes_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseRepository localDB;

  const HomeScreen(
    this.localDB, {
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // state
  Future<Map<String, dynamic>>? _jokeDataFuture;
  late Future<List<dynamic>> _jokeCategoriesFuture;
  final String _jokeInitialCategory =
      'dev'; // Initial category to fetch jokes from

  Future<List<String>>? _favoriteIds;
  IconData _favIcon = Icons.favorite_border;
  bool isFavorite = false;

  // controllers
  final TextEditingController jokeCategoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _jokeCategoriesFuture = JokesService().fetchJokeCategories();
    _jokeDataFuture = JokesService().fetchRandomJoke(_jokeInitialCategory);
    _favoriteIds = _loadFavoritesIds();
  }

  void _updateCategory(String category) {
    setState(() {
      _jokeDataFuture = JokesService().fetchRandomJoke(category);
    });
  }

  Future<List<String>> _loadFavoritesIds() async {
    List<String> jokesIds = await widget.localDB.getJokesIds();
    if (jokesIds.isEmpty) {
      return [];
    }
    return jokesIds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chuck Norris Jokes'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.only(
              left: 16.0,
              right: 16.0,
              top: 32.0,
              bottom: 16.0,
            ),
            child: Center(
              child: Column(
                spacing: 16,
                children: [
                  FutureBuilder(
                    future: _jokeCategoriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No categories found');
                      }
                      final categories = snapshot.data!;
                      List<DropdownMenuEntry<String>> getDropdownMenuEntrys() {
                        List<DropdownMenuEntry<String>> entries = categories
                            .map(
                              (category) => DropdownMenuEntry<String>(
                                value: category,
                                label: category,
                              ),
                            )
                            .toList();
                        return entries;
                      }

                      return DropdownMenu(
                        initialSelection: _jokeInitialCategory,
                        controller: jokeCategoryController,
                        label: const Text('Choose category:'),
                        width: double.infinity,
                        onSelected: (value) {
                          _updateCategory(value ?? _jokeInitialCategory);
                        },
                        dropdownMenuEntries: [
                          for (final entry in getDropdownMenuEntrys()) entry,
                        ],
                      );
                    },
                  ),
                  Text(
                    'Category: ${jokeCategoryController.text.toUpperCase()}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.topCenter,
                      child: FutureBuilder(
                        future: _jokeDataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return Text(
                              'Please choose category first',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          final Map<String, dynamic> jokeData =
                              snapshot.data ?? {};
                          final String jokeFuture =
                              jokeData['value'] ?? 'No joke found';

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                jokeFuture,
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              FutureBuilder(
                                future: _favoriteIds,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      'Error: ${snapshot.error}',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null ||
                                      snapshot.data!.isEmpty) {
                                    final jokeId = jokeData['id'] ?? '';

                                    return IconButton(
                                      onPressed: () async {
                                        await widget.localDB.addJokeId(jokeId);
                                        setState(() {
                                          isFavorite = true;
                                          _favoriteIds = _loadFavoritesIds();
                                          _favIcon = Icons.favorite;
                                        });
                                      },
                                      icon: Icon(
                                        _favIcon,
                                        size: 32,
                                        color: Colors.red,
                                      ),
                                    );
                                  }

                                  final jokeId = jokeData['id'] ?? '';
                                  final favoriteIds = snapshot.data ?? [];
                                  if (favoriteIds.contains(jokeId)) {
                                    isFavorite = true;
                                    _favIcon = Icons.favorite;
                                  } else {
                                    isFavorite = false;
                                    _favIcon = Icons.favorite_border;
                                  }

                                  return IconButton(
                                    onPressed: isFavorite
                                        ? null
                                        : () async {
                                            await widget.localDB.addJokeId(
                                              jokeId,
                                            );

                                            setState(() {
                                              isFavorite = true;
                                              _favoriteIds =
                                                  _loadFavoritesIds();
                                            });
                                          },
                                    icon: Icon(
                                      _favIcon,
                                      size: 32,
                                      color: Colors.red,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: jokeCategoryController.text.isEmpty
                        ? () {
                            _updateCategory(_jokeInitialCategory);
                          }
                        : () {
                            _updateCategory(jokeCategoryController.text);
                          },
                    child: Text(
                      'Get one more ${jokeCategoryController.text.toUpperCase()} - joke',
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FavoritesScreen(widget.localDB),
                        ),
                      );
                    },
                    child: Text('Show my Favorites'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    jokeCategoryController.dispose();
    super.dispose();
  }
}
