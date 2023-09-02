import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fire_base_register/screens/home_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  List<String> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _getUser();
    _getFavoriteMovies();
  }

  Future<void> _getUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  Future<void> _getFavoriteMovies() async {
    if (_user != null) {
      final userId = _user!.uid;
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favoriteMovies')
          .get();

      final favoriteMovies = snapshot.docs.map((doc) {
        return doc['name'] as String;
      }).toList();

      setState(() {
        _favoriteMovies = favoriteMovies;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        title: Text('Your Favorite Movies'),
        backgroundColor:
            Colors.black, // Match the app bar background color with the screen
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to the HomeScreen (replace HomeScreen with your actual home screen)
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen()), // Replace HomeScreen with your home screen
              (Route<dynamic> route) =>
                  false, // Remove all routes below the HomeScreen
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _favoriteMovies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _favoriteMovies[index],
                      style: TextStyle(
                        color: Colors.white, // Set text color to white
                      ),
                    ),
                    // You can add more widgets or actions here
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
