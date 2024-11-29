import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewsPage extends StatefulWidget {
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  List<Map<String, dynamic>> _reviews = [];
  final baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<void> fetchReviews() async {
    try {
      final response = await http.get(Uri.parse(baseUrl + '/reviews'));
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unexpected data format')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch reviews')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
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
        title: const Text('User Reviews'),
        backgroundColor: const Color(0xFF18654A),
        centerTitle: true,
        elevation: 2,
      ),
      body: _reviews.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                final rating = (review['rating'] ?? 0).toInt();

                // Parsing tanggal dari API
                final rawDate = review['date'];
                final parsedDate = DateTime.tryParse(rawDate ?? '') ?? DateTime.now();
                final timeAgo = timeago.format(parsedDate, locale: 'en');

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF18654A),
                              child: Text(
                                (review['username']?[0] ?? '-').toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review['username'] ?? 'Anonymous',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    timeAgo,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              Icons.star,
                              color: i < rating
                                  ? const Color(0xFFFFD700)
                                  : Colors.grey[300],
                              size: 20,
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          review['comment'] ?? 'No comment available',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
