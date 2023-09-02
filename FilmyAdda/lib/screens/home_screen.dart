import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_fire_base_register/screens/description.dart';
import 'package:flutter_fire_base_register/screens/welcome_screen.dart';
import 'package:flutter_fire_base_register/widgets/favorite.dart';
import 'package:flutter_fire_base_register/utils/text.dart';
import 'package:flutter_fire_base_register/auth/auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthServices _serives = AuthServices();

  void logOut(BuildContext context) {
    _serives.logOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(),
      ),
    );
  }

  final String apiKey = 'a4279716a96ce280eafb483ecf220f6d';
  final String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNDI3OTcxNmE5NmNlMjgwZWFmYjQ4M2VjZjIyMGY2ZCIsInN1YiI6IjY0ZTVjMzc2YzYxM2NlMDBlYWE3YWNiNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JQsmjYHQW_JBp-EvEXtYmr_ETgxflIMWymRXzOv6tNM';

  List trendingMovies = [];
  List topRatedMovies = [];
  List tv = [];
  List searchedMovies = [];

  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;
  // ignore: unused_field
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    loadMovies();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  loadMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys('a4279716a96ce280eafb483ecf220f6d',
          'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNDI3OTcxNmE5NmNlMjgwZWFmYjQ4M2VjZjIyMGY2ZCIsInN1YiI6IjY0ZTVjMzc2YzYxM2NlMDBlYWE3YWNiNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JQsmjYHQW_JBp-EvEXtYmr_ETgxflIMWymRXzOv6tNM'),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map trendingResult = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map topRatedResult = await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map tvResult = await tmdbWithCustomLogs.v3.tv.getPopular();

    setState(() {
      trendingMovies = trendingResult['results'];
      topRatedMovies = topRatedResult['results'];
      tv = tvResult['results'];
    });
  }

  searchMovies(String query) async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys('a4279716a96ce280eafb483ecf220f6d',
          'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNDI3OTcxNmE5NmNlMjgwZWFmYjQ4M2VjZjIyMGY2ZCIsInN1YiI6IjY0ZTVjMzc2YzYxM2NlMDBlYWE3YWNiNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JQsmjYHQW_JBp-EvEXtYmr_ETgxflIMWymRXzOv6tNM'),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map searchResult = await tmdbWithCustomLogs.v3.search.queryMulti(query);

    setState(() {
      searchedMovies = searchResult['results'];
    });
  }

  void toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: _showSearchBar
            ? TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search for movies...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onSubmitted: (query) {
                  searchMovies(query);
                },
              )
            : Text(
                'FilmyAdda',
                style: GoogleFonts.roboto(color: Colors.white),
              ),
        actions: [
          IconButton(
            icon: Icon(_showSearchBar ? Icons.close : Icons.search),
            onPressed: toggleSearchBar,
          ),
          IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => FavoritesScreen()));
              }),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                logOut(context);
              }),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          if (searchedMovies.isNotEmpty) SearchResults(results: searchedMovies),
          if (trendingMovies.isNotEmpty)
            TrendingMovies(trending: trendingMovies),
          if (topRatedMovies.isNotEmpty)
            TopRatedMovies(toprated: topRatedMovies),
          if (tv.isNotEmpty) TV(tv: tv),
        ],
      ),
    );
  }
}

class SearchResults extends StatelessWidget {
  final List results;

  SearchResults({required this.results});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          "Search Results",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          itemCount: results.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(results[index]['title'],
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Description(
                      name: results[index]['title'],
                      bannerurl: 'https://image.tmdb.org/t/p/w500' +
                          results[index]['backdrop_path'],
                      posterurl: 'https://image.tmdb.org/t/p/w500' +
                          results[index]['poster_path'],
                      description: results[index]['overview'],
                      vote: results[index]['vote_average'].toString(),
                      launchOn: results[index]['release_date'],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class MovieDetails extends StatefulWidget {
  final int movieId;

  MovieDetails({required this.movieId});

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  Map movieDetails = {};

  @override
  void initState() {
    super.initState();
    loadMovieDetails();
  }

  loadMovieDetails() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys('a4279716a96ce280eafb483ecf220f6d',
          'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNDI3OTcxNmE5NmNlMjgwZWFmYjQ4M2VjZjIyMGY2ZCIsInN1YiI6IjY0ZTVjMzc2YzYxM2NlMDBlYWE3YWNiNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JQsmjYHQW_JBp-EvEXtYmr_ETgxflIMWymRXzOv6tNM'),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map details = await tmdbWithCustomLogs.v3.movies.getDetails(widget.movieId);

    setState(() {
      movieDetails = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movieDetails['title'] ?? 'Movie Details'),
      ),
      body: Center(
        child: Text(movieDetails['overview'] ?? 'No overview available.'),
      ),
    );
  }
}

class TrendingMovies extends StatelessWidget {
  final List trending;

  const TrendingMovies({Key? key, required this.trending}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModifiedText(
            text: 'Trending Movies',
            size: 26,
          ),
          SizedBox(height: 10),
          Container(
              height: 270,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trending.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Description(
                                      name: trending[index]['title'],
                                      bannerurl:
                                          'https://image.tmdb.org/t/p/w500' +
                                              trending[index]['backdrop_path'],
                                      posterurl:
                                          'https://image.tmdb.org/t/p/w500' +
                                              trending[index]['poster_path'],
                                      description: trending[index]['overview'],
                                      vote: trending[index]['vote_average']
                                          .toString(),
                                      launchOn: trending[index]['release_date'],
                                    )));
                      },
                      child: Container(
                        width: 140,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500' +
                                          trending[index]['poster_path']),
                                ),
                              ),
                              height: 200,
                            ),
                            SizedBox(height: 5),
                            Container(
                              child: ModifiedText(
                                  size: 15,
                                  text: trending[index]['title'] != null
                                      ? trending[index]['title']
                                      : 'Loading'),
                            )
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}

class TopRatedMovies extends StatelessWidget {
  final List toprated;

  const TopRatedMovies({Key? key, required this.toprated}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModifiedText(
            text: 'Top Rated Movies',
            size: 26,
          ),
          SizedBox(height: 10),
          Container(
              height: 270,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: toprated.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Description(
                                      name: toprated[index]['title'],
                                      bannerurl:
                                          'https://image.tmdb.org/t/p/w500' +
                                              toprated[index]['backdrop_path'],
                                      posterurl:
                                          'https://image.tmdb.org/t/p/w500' +
                                              toprated[index]['poster_path'],
                                      description: toprated[index]['overview'],
                                      vote: toprated[index]['vote_average']
                                          .toString(),
                                      launchOn: toprated[index]['release_date'],
                                    )));
                      },
                      child: Container(
                        width: 140,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500' +
                                          toprated[index]['poster_path']),
                                ),
                              ),
                              height: 200,
                            ),
                            SizedBox(height: 5),
                            Container(
                              child: ModifiedText(
                                  size: 15,
                                  text: toprated[index]['title'] != null
                                      ? toprated[index]['title']
                                      : 'Loading'),
                            )
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}

class TV extends StatelessWidget {
  final List tv;

  const TV({Key? key, required this.tv}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModifiedText(
            text: 'Popular TV Shows',
            size: 26,
          ),
          SizedBox(height: 10),
          Container(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tv.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: tv[index]
                              ['name'], // Use 'name' or 'original_name'
                          bannerurl: 'https://image.tmdb.org/t/p/w500' +
                              tv[index]['backdrop_path'],
                          posterurl: 'https://image.tmdb.org/t/p/w500' +
                              tv[index]['poster_path'],
                          description: tv[index]['overview'],
                          vote: tv[index]['vote_average'].toString(),
                          launchOn: tv[index]
                              ['first_air_date'], // Use 'first_air_date'
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500' +
                                      tv[index]['poster_path']),
                            ),
                          ),
                          height: 200,
                        ),
                        SizedBox(height: 5),
                        Container(
                          child: ModifiedText(
                            size: 15,
                            text: tv[index]['name'] != null
                                ? tv[index]
                                    ['name'] // Use 'name' or 'original_name'
                                : 'Loading',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
