import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;
import 'package:http/http.dart' as http;
import '../services/token_service.dart';
import '../controller/AuthController.dart';
import 'package:get/get.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _guestCount = 1;
  String? _tablePreference;
  final String baseUrl = dot_env.dotenv.env['BASE_URL'] ?? "";
  MidtransSDK? _midtrans;
  final AuthController _authController = Get.find();

  @override
  void initState() {
    super.initState();
    _initSDK();
  }

  void _initSDK() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: dot_env.dotenv.env['MIDTRANS_CLIENT_KEY'] ?? "",
        merchantBaseUrl: "",
        colorTheme: ColorTheme(
          colorPrimary: Colors.blue,
          colorPrimaryDark: Colors.blue,
          colorSecondary: Colors.blue,
        ),
      ),
    );

    _midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
    );

    _midtrans!.setTransactionFinishedCallback((result) {
      _handleTransactionResult(result);
    });
  }

  void _handleTransactionResult(TransactionResult result) {
      print('Transaction Details: ${result.transactionId}, ${result.paymentType}');
        _submitReservation();
  }

  void _submitReservation() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _emailController.text.isEmpty || _selectedDate == null || _selectedTime == null) {
      _showToast('Please fill all fields before submitting', true);
      return;
    }

    final String formattedDate =
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
    final String formattedTime =
        '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

    final Map<String, dynamic> reservationData = {
      'user_id': _authController.id.value,
      'name': _nameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'date': formattedDate,
      'time': formattedTime,
      'guest_count': _guestCount,
      'table_preference': _tablePreference ?? '',
    };

    final response = await http.post(
      Uri.parse(baseUrl + '/reservations' ?? ""),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reservationData),
    );

    if (response.statusCode == 201) {
      _showToast('Reservation submitted successfully!', false);
    } else {
      _showToast('Failed to submit reservation: ${response.body}', true);
    }
  }

  void _showToast(String msg, bool isError) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    _midtrans?.removeTransactionFinishedCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation and Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: const Text('Select Date'),
                ),
                SizedBox(width: 8),
                Text(_selectedDate == null
                    ? 'No date selected'
                    : '${_selectedDate!.toLocal()}'.split(' ')[0]),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime ?? TimeOfDay.now(),
                    );
                    if (picked != null && picked != _selectedTime) {
                      setState(() {
                        _selectedTime = picked;
                      });
                    }
                  },
                  child: const Text('Select Time'),
                ),
                SizedBox(width: 8),
                Text(_selectedTime == null
                    ? 'No time selected'
                    : '${_selectedTime!.format(context)}'),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                _tablePreference = value;
              },
              decoration: const InputDecoration(labelText: 'Table Preference'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                const Text('Guest Count: '),
                DropdownButton<int>(
                  value: _guestCount,
                  items: List.generate(
                    10,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1} guests'),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _guestCount = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initiatePayment,
              child: const Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _initiatePayment() async {
    try {
      final tokenResult = await TokenService().getToken();

      tokenResult.fold(
        (error) {
          _showToast('Failed to get payment token', true);
        },
        (tokenData) {
          if (tokenData.token != null) {
            _midtrans?.startPaymentUiFlow(
              token: tokenData.token!,
            );
          } else {
            _showToast('Invalid Payment Token', true);
          }
        },
      );
    } catch (e) {
      _showToast('Payment Initiation Error', true);
      print('Payment Error: $e');
    }
  }
}
