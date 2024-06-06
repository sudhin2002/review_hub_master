
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:review_hub_admin/constants/color.dart';
import 'package:review_hub_admin/customWidgets/customText.dart';
import 'package:review_hub_admin/dashboard.dart';
import 'package:review_hub_admin/login.dart';
import 'package:review_hub_admin/channels.dart';
import 'package:review_hub_admin/restaurents.dart';
import 'package:review_hub_admin/services.dart';
import 'package:review_hub_admin/babyproducts.dart';
import 'package:review_hub_admin/add.dart';

class Movies extends StatefulWidget {
  const Movies({Key? key}) : super(key: key);

  @override
  _MoviesState createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  late final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final String _moviesCollection = 'items'; // Replace with actual collection name

  late Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _futureMovies;

  @override
  void initState() {
    super.initState();
    _futureMovies = _fetchMovies();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchMovies() async {
    try {
      final querySnapshot = await _firestore.collection(_moviesCollection).where('category',isEqualTo: 'Movie').get();
      return querySnapshot.docs.toList();
    } catch (error) {
      print('Error fetching movies: $error');
      rethrow; // Rethrow for error handling in FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: const Text("Movies Review"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(text: 'Movies', weight: FontWeight.bold, size: 18, textcolor: customBalck),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20,
                  unratedColor: Colors.grey,
                  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    // Implement your functionality with the rating value
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              future: _futureMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  final movies = snapshot.data!;
                  return ResponsiveGridList(
                    desiredItemWidth:300,
                    minSpacing: 10,
                    children: movies.map((movie) => _buildMovieCard(movie)).toList(),
                  );
                } else {
                  return const Text('No movies found');
                }
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: maincolor,
              ),
              child: Text('Navigation Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
              },
            ),
            ListTile(
              title: Text('Movies'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Movies()));
              },
            ),
            ListTile(
              title: Text('Restaurants'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Restaurants()));
              },
            ),
            ListTile(
              title: Text('Channels'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Channel()));
              },
            ),
            ListTile(
              title: Text('Services'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Services()));
              },
            ),
            ListTile(
              title: Text('Baby Products'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BabyProducts()));
              },
            ),
            ListTile(
              title: Text('Add New Item'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Add()));
              },
            ),
             ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
      ),
      
    );
  }
  Widget _buildMovieCard(QueryDocumentSnapshot<Map<String, dynamic>> movie) {
  final movieData = movie.data();
  if (movieData == null) return const SizedBox(); // Handle potential null data

  final imageUrl = movieData['image_url'] as String;
  final name = movieData['name'] as String;

  return Card(
    child: Container(
      height: 300,
      width: 150,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 240,
            width: 350,
            child: Image.network(
              imageUrl,
              
              fit: BoxFit.cover,
              // errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
          ),
          SizedBox(height: 10),
          Text(name ?? 'No name', style: TextStyle(color: customBalck, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

}
