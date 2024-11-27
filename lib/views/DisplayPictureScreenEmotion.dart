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
    switch (emotion.toLowerCase()) {
      case 'senang':
        starInt = 5;
        return '★★★★★';
      case 'terkejut':
        starInt = 4;
        return '★★★★☆';
      case 'netral':
        starInt = 3;
        return '★★★☆☆';
      case 'takut':
        starInt = 2;
        return '★★☆☆☆';
      case 'jijik':
        starInt = 1;
        return '★☆☆☆☆';
      case 'sedih':
        starInt = 1;
        return '★☆☆☆☆';
      case 'marah':
        starInt = 1;
        return '★☆☆☆☆';
      default:
        starInt = 0;
        return '☆☆☆☆☆';
    }
  }

  Future<void> sendReview(int starInt, String review) async {
    try {
      final url = Uri.parse(
          baseUrl + '/review');
      final requestBody = jsonEncode({
        'user_id': _authController.id.value,
        'rating': starInt,
        'comment': review,
      });

      // Log the request body for debugging
      print('Sending request body: $requestBody');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print("Review submitted successfully");
      } else {
        print("Failed to submit review: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error submitting review: $e");
    }
  }

  Future<void> predictEmotion() async {
    setState(() {
      emotionResult = "Loading...";
      confidence = "";
    });

    try {
      final url = Uri.parse(
          baseUrl + '/predict');
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
        });
      } else {
        setState(() {
          emotionResult =
              "Failed to get prediction (Status: ${streamedResponse.statusCode})";
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
      appBar: AppBar(title: const Text('Display the Picture')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: kIsWeb
                  ? Image.network(widget.imagePath)
                  : Image.file(
                      File(widget.imagePath),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                    ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Emotion Detection Result',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFF18654A)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 8),
                                Text(
                                  starRating,
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  emotionResult,
                                  style: TextStyle(color: Color(0xFF18654A)),
                                ),
                              ],
                            ),
                          ]),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              String userReview = "";

                              return AlertDialog(
                                title: Text("Tulis Ulasan"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        hintText:
                                            "Tulis ulasan Anda di sini...",
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        userReview = value;
                                      },
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context), // Tutup dialog
                                    child: Text("Batal"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (userReview.isNotEmpty) {
                                        await sendReview(starInt,
                                            userReview); 
                                        Navigator.pop(
                                            context);
                                        setState(() {
                                        });
                                      } else {
                                        setState(() {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "Please enter a review")),
                                          );
                                        });
                                      }
                                    },
                                    child: Text("Submit"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF18654A),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Tulis Ulasan'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
