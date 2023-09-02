import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fire_base_register/utils/text.dart';

class Description extends StatefulWidget {
  final String name, description, bannerurl, posterurl, vote, launchOn;

  const Description({
    Key? key,
    required this.name,
    required this.description,
    required this.bannerurl,
    required this.posterurl,
    required this.vote,
    required this.launchOn,
  }) : super(key: key);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        // Call a function to add the movie to the user's favorites in Firestore
        _addMovieToFavorites(widget.name);
      } else {
        // Call a function to remove the movie from the user's favorites in Firestore
        _removeMovieFromFavorites(widget.name);
      }
    });
  }

  Future<void> _addMovieToFavorites(String movieName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('favoriteMovies')
          .doc(movieName)
          .set({
        'name': movieName,
      });
    }
  }

  Future<void> _removeMovieFromFavorites(String movieName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('favoriteMovies')
          .doc(movieName)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Movie Description'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: toggleFavorite,
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 250,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        widget.bannerurl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child:
                        ModifiedText(text: '⭐Average Rating⭐ ' + widget.vote),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(10),
              child: ModifiedText(
                text: widget.name ?? 'Not Loaded',
                size: 24,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: ModifiedText(
                text: 'Releasing On - ' + widget.launchOn,
                size: 14,
              ),
            ),
            Row(
              children: [
                Container(
                  height: 200,
                  width: 100,
                  child: Image.network(widget.posterurl),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: ModifiedText(
                      text: widget.description,
                      size: 18,
                      color: null,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
