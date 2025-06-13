import 'package:api_542_task/jokes_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // state
  Future<String>? _jokeFuture;
  late Future<List<dynamic>> _jokeCategoriesFuture;

  // controllers
  final TextEditingController jokeCategoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _jokeCategoriesFuture = JokesService().fetchJokeCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chuck Norris Jokes'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.only(
            left: 16.0,
            right: 16.0,
            top: 32.0,
            bottom: 16.0,
          ),
          child: Center(
            child: Column(
              spacing: 32,
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
                      initialSelection: '',
                      controller: jokeCategoryController,
                      label: const Text('Choose category:'),
                      width: double.infinity,
                      onSelected: (value) {
                        setState(() {
                          _jokeFuture = JokesService().fetchRandomJoke(
                            value ?? '',
                          );
                        });
                      },
                      dropdownMenuEntries: [
                        for (final entry in getDropdownMenuEntrys()) entry,
                      ],
                    );
                  },
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
                      future: _jokeFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Text('No joke found');
                        }
                        final String jokeFuture =
                            snapshot.data ?? 'No joke found';

                        return Text(
                          jokeFuture,
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
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
