import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controller/AuthController.dart';
import 'package:get/get.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RefundPage extends StatefulWidget {
  const RefundPage({super.key});

  @override
  _RefundPageState createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  final AuthController _authController = Get.find();
  final baseUrl = dotenv.env['BASE_URL'] ?? '';
  List<dynamic> refunds = [];
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/admin');
        break;
      case 1:
        Navigator.pushNamed(context, '/refund');
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _getRefunds();
  }

  Future<void> _getRefunds() async {
    final response = await http.get(Uri.parse('$baseUrl/refunds'));

    if (response.statusCode == 200) {
      setState(() {
        refunds = jsonDecode(response.body);
      });
    } else {
      print("Failed to load refunds: ${response.body}");
      DangerAlertBox(
        context: context,
        title: "Error",
        messageText: "Failed to load refunds",
        buttonColor: Colors.red,
        buttonText: "OK",
      );
    }
  }

  Future<void> _updateRefundStatus(int refundId, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/refunds/$refundId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      setState(() {
        refunds = refunds.map((refund) {
          if (refund['id'] == refundId) {
            refund['status'] = status;
          }
          return refund;
        }).toList();
      });
      SuccessAlertBox(
        context: context,
        title: "Success",
        messageText: "Refund berhasil $status.",
        buttonColor: Colors.green,
        buttonText: "OK",
      );
    } else {
      print("Failed to update refund status: ${response.body}");
      DangerAlertBox(
        context: context,
        title: "Error",
        messageText: "Failed to update refund status.",
        buttonColor: Colors.red,
        buttonText: "OK",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Refund Management"),
      ),
      body: refunds.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: refunds.length,
              itemBuilder: (context, index) {
                final refund = refunds[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Refund ID: ${refund['id']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Transaction ID: ${refund['transaction_id']}'),
                        Text('Reservation ID: ${refund['reservation_id']}'),
                        Text('Status: ${refund['status']}'),
                      ],
                    ),
                    trailing: refund['status'] == 'Belum diproses'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check,
                                    color: Colors.green),
                                onPressed: () async {
                                  // Menampilkan modal konfirmasi reservasi
                                  bool? confirmed = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Konfirmasi"),
                                        content: Text(
                                            "Apakah Anda yakin ingin menghapus reservasi ini?"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("Tidak"),
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  false); // Tidak hapus reservasi
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Ya"),
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  true); // Ya, hapus reservasi
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // Jika user mengonfirmasi reservasi, jalankan proses reservasi
                                  if (confirmed == true) {
                                    try {
                                      _updateRefundStatus(
                                          refund['id'], 'Diterima');
                                    } catch (e) {
                                      print("Error cancel reservation: $e");
                                    }
                                  }
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () async {
                                  // Menampilkan modal konfirmasi reservasi
                                  bool? confirmed = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            Text("Konfirmasi Hapus Reservasi"),
                                        content: Text(
                                            "Apakah Anda yakin ingin menghapus reservasi ini?"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("Tidak"),
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  false); // Tidak hapus reservasi
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Ya"),
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  true); // Ya, hapus reservasi
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // Jika user mengonfirmasi reservasi, jalankan proses reservasi
                                  if (confirmed == true) {
                                    try {
                                      _updateRefundStatus(
                                          refund['id'], 'Ditolak');
                                    } catch (e) {
                                      print("Error cancel reservation: $e");
                                    }
                                  }
                                },
                              ),
                            ],
                          )
                        : const Icon(Icons.done, color: Colors.grey),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Refund',
          ),
        ],
        selectedItemColor: const Color(0xFF18654A), // your primary green color
        unselectedItemColor: const Color(0xFF18654A),
        onTap: _onItemTapped,
      ),
    );
  }
}
