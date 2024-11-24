import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewsPage extends StatefulWidget {
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  List<Map<String, dynamic>> _reviews = [];

  Future<void> fetchReviews() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/reviews')); // Ganti URL sesuai API Flask kamu
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data is List) {
          setState(() {
            _reviews = List<Map<String, dynamic>>.from(data);
          });
        } else if (data is Map && data['reviews'] is List) {
          setState(() {
            _reviews = List<Map<String, dynamic>>.from(data['reviews']);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unexpected data format')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch reviews')));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Reviews'),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        elevation: 5,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _reviews.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black45,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 30,
                      ),
                      title: Text(
                        'Rating: ${review['rating']}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        review['comment'] ?? 'No comment available',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
