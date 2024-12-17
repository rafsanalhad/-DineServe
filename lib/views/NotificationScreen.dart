import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../controller/AuthController.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<Notification>> _notifications;
  final baseUrl = dotenv.env['BASE_URL'] ?? '';
  final AuthController _authController = Get.find();

  @override
  void initState() {
    super.initState();
    _notifications = fetchNotifications();
  }

  Future<List<Notification>> fetchNotifications() async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/${_authController.id.value}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['notif'];
      return data.map((item) => Notification.fromJson(item)).toList();
    } else {
      throw Exception('No notifications available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: FutureBuilder<List<Notification>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications available.'));
          } else {
            final notifications = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return NotificationCard(notification: notification);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Notification notification;

  const NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Type: Reservation',
              style: TextStyle(
                fontSize: 14.0,
                fontStyle: FontStyle.italic,
                color: notification.status == 'read'
                    ? Colors.grey
                    : Colors.green,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Timestamp: ${notification.timestamp}',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Notification {
  final int id;
  final int userId;
  final String message;
  final String status;
  final String timestamp;

  Notification({
    required this.id,
    required this.userId,
    required this.message,
    required this.status,
    required this.timestamp,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      userId: json['user_id'],
      message: json['message'],
      status: json['status'],
      timestamp: json['timestamp'],
    );
  }
}
