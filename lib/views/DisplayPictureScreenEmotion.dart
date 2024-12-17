import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controller/AuthController.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/ListReservasi.dart';

class DisplayPictureScreenEmotion extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreenEmotion({Key? key, required this.imagePath})
      : super(key: key);

  @override
  _DisplayPictureScreenEmotionState createState() =>
      _DisplayPictureScreenEmotionState();
}

class _DisplayPictureScreenEmotionState
    extends State<DisplayPictureScreenEmotion> {
  final AuthController _authController = Get.find();
  String emotionResult = "Awaiting result...";
  String confidence = "";
  String starRating = "☆☆☆☆☆";
  int starInt = 0;
  final baseUrl = dotenv.env['BASE_URL'] ?? '';
  String getStarRating(String emotion) {
    switch (emotion) {
      case 'Surprise':
        starInt = 5;
        return '★★★★★';
      case 'Happy':
        starInt = 4;
        return '★★★★☆';
      case 'Neutral':
        starInt = 3;
        return '★★★☆☆';
      case 'Sad':
        starInt = 2;
        return '★★☆☆☆';
      case 'Angry':
        starInt = 1;
        return '★☆☆☆☆';
      default:
        starInt = 0;
        return '☆☆☆☆☆';
    }
  }

  Future<void> predictEmotion() async {
    setState(() {
      emotionResult = "Loading...";
      confidence = "";
    });

    try {
      final url = Uri.parse(baseUrl + '/predict');
      print('Sending request to: $url');

      final request = http.MultipartRequest('POST', url);
      if (!kIsWeb) {
        final file = File(widget.imagePath);

        if (!await file.exists()) {
          setState(() {
            emotionResult = "Error: Image file not found";
            confidence = "";
          });
          return;
        }

        final multipartFile = await http.MultipartFile.fromPath(
          'file',
          widget.imagePath,
          filename: 'image.jpg',
        );

        request.files.add(multipartFile);
        print('File added to request: ${widget.imagePath}');
      } else {
        print("Running on the web, no file handling");
        setState(() {
          emotionResult = "Web platform detected, skipping file upload";
        });
        return;
      }

      final streamedResponse = await request.send();

      final responseBody = await streamedResponse.stream.bytesToString();
      print('Response status code: ${streamedResponse.statusCode}');
      print('Response body: $responseBody');

      if (streamedResponse.statusCode == 200) {
        final data = jsonDecode(responseBody);
        setState(() {
          emotionResult = data['max_emotion'] ?? "Unknown";
          confidence = "${data['max_percentage'] ?? 0}%";
          starRating = getStarRating(emotionResult);
          print('emotion: $emotionResult');
        });
      } else {
        setState(() {
          emotionResult = "No Face Detected";
          confidence = "";
          starRating = "☆☆☆☆☆";
        });
      }
    } catch (e) {
      print('Error in predictEmotion: $e');
      setState(() {
        emotionResult = "Error: ${e.toString()}";
        confidence = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    predictEmotion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Tombol back
          },
        ),
        backgroundColor:
            Colors.transparent, // Membuat background app bar transparan
        elevation: 0, // Menghilangkan shadow
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar Face Recognition (diperbesar dan bulat)
              Center(
                child: ClipOval(
                  child: kIsWeb
                      ? Image.network(
                          widget.imagePath,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(widget.imagePath),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              const SizedBox(height: 30),

              // Face Recognition Text
              const Text(
                'Emotion Detected',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              Text(
                emotionResult,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF18654A),
                ),
              ),
              Text(
                starRating,
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Instruction Text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "This result is the predicted emotion from the uploaded image. Please provide your feedback to help us improve our service.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Tombol Get Started dengan lebar penuh
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity, // Mengatur lebar tombol menjadi penuh
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return CommentBottomSheet(starInt: starInt);
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF18654A), // Warna tombol
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Leave a Comment',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentBottomSheet extends StatefulWidget {
  final int starInt; // Menerima rating dari konstruktor

  CommentBottomSheet(
      {required this.starInt}); // Konstruktor dengan nilai starInt

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final baseUrl = dotenv.env['BASE_URL'] ?? '';
  final AuthController _authController = Get.find();

  Future<void> sendReview(int starInt, String review) async {
    try {
      final url = Uri.parse(baseUrl + '/review');
      final requestBody = jsonEncode({
        'user_id': _authController.id.value,
        'rating': starInt,
        'comment': review,
      });
      print('Sending request body: $requestBody');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 201) {
        print("Review submitted successfully");
        // Menampilkan modal sukses yang trendy
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Review submitted successfully."),
            backgroundColor: Color(0xFF18654A),
          ),
        );
      } else {
        print("Failed to submit review: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error submitting review: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Leave a Comment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Write your comment...",
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    maxLines: 5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Your comments are very helpful in improving our service.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      String userReview = _controller.text.trim();
                      if (userReview.isNotEmpty) {
                        await sendReview(widget.starInt, userReview);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please leave a review")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF18654A),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Send Review',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
