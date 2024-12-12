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
  double _averageRating = 0.0;
  String _filterOption = 'Default';

  final baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<void> fetchReviews() async {
    try {
      final response = await http.get(Uri.parse(baseUrl + '/reviews'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data is List) {
          setState(() {
            _reviews = List<Map<String, dynamic>>.from(data);
            _calculateAverageRating();
          });
        } else if (data is Map && data['reviews'] is List) {
          setState(() {
            _reviews = List<Map<String, dynamic>>.from(data['reviews']);
            _calculateAverageRating();
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

  void _calculateAverageRating() {
    if (_reviews.isEmpty) return;

    double totalRating = _reviews.fold(0.0, (sum, item) => sum + (item['rating'] ?? 0).toDouble());
    setState(() {
      _averageRating = totalRating / _reviews.length;
    });
  }

  void _applyFilter() {
    setState(() {
      if (_filterOption == 'Highest') {
        _reviews.sort((a, b) => (b['rating'] ?? 0).compareTo(a['rating'] ?? 0));
      } else if (_filterOption == 'Lowest') {
        _reviews.sort((a, b) => (a['rating'] ?? 0).compareTo(b['rating'] ?? 0));
      }
    });
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
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Header with average rating and filter dropdown
          Container(
            color: const Color(0xFF18654A),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Average Rating Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Average Rating',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          Icons.star,
                          color: i < _averageRating.toInt()
                              ? const Color(0xFFFFD700) // Gold for filled stars
                              : Colors.grey[300], // Grey for empty stars
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_averageRating.toStringAsFixed(1)} / 5 (${_reviews.length} reviews)',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                // Filter Dropdown
                DropdownButton<String>(
                  value: _filterOption,
                  dropdownColor: const Color(0xFF18654A),
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(
                      value: 'Default',
                      child: Text('Default'),
                    ),
                    DropdownMenuItem(
                      value: 'Highest',
                      child: Text('Highest Rating'),
                    ),
                    DropdownMenuItem(
                      value: 'Lowest',
                      child: Text('Lowest Rating'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _filterOption = value;
                        _applyFilter();
                      });
                    }
                  },
                  underline: Container(height: 0),
                ),
              ],
            ),
          ),
          // Review List
          Expanded(
            child: _reviews.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _reviews.length,
                    itemBuilder: (context, index) {
                      final review = _reviews[index];
                      final rating = (review['rating'] ?? 0).toInt();
                      final rawDate = review['date'];
                      final profilePicture = review['image'];
                      final parsedDate = DateTime.tryParse(rawDate ?? '') ?? DateTime.now();
                      final timeAgo = timeago.format(parsedDate, locale: 'en');

                      print("Review: $review");

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                      baseUrl + '/uploads/$profilePicture'),
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
          ),
        ],
      ),
    );
  }
}
