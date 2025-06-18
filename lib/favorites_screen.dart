import 'package:api_542_task/jokes_service.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // State

  final Future<Map<String, dynamic>> _favoritesFuture = JokesService()
      .fetchJokeFromHTML('mg4dqtopqj-wbduf8rf_mw');

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
              Image.network(
                'https://api.chucknorris.io/img/chucknorris_logo_coloured_small.png',
                width: 300,
              ),
              SizedBox(height: 32),
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _favoritesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text('No favorites found.'));
                    } else {
                      final joke = snapshot.data!;
                      //debugPrint(joke.toString());
                      return ListTile(
                        title: Text(joke['value']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {},
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
