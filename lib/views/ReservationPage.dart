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
  String? _selectedTime;
  int _guestCount = 1;
  String? _tablePreference;
  final String baseUrl = dot_env.dotenv.env['BASE_URL'] ?? "";
  MidtransSDK? _midtrans;
  final AuthController _authController = Get.find();
  List<Map<String, dynamic>> tables = [];
  List<String> availableTimes = [
    '07:00 - 08:00',
    '08:00 - 09:00',
    '09:00 - 10:00'
  ]; // Opsi waktu

  Future<void> fetchTables() async {
    try {
      final response = await http.get(Uri.parse(baseUrl + '/getAllTables'));

      if (response.statusCode == 200) {
        // Parse response body and extract full table data
        final List<dynamic> data = json.decode(response.body)['tables'];
        setState(() {
          tables = data
              .map((table) => {
                    'id': table['id'],
                    'table_number': table['table_number']
                  })
              .toList();

          // Optionally set a default table selection
          if (tables.isNotEmpty) {
            _tablePreference = tables[0]['id'].toString();
          }
        });
        print("Fetched tables: $tables");
      } else {
        // Handle error if failed to fetch data
        throw Exception('Failed to load tables');
      }
    } catch (e) {
      print('Error fetching tables: $e');
      _showToast('Failed to load tables', true);
    }
  }

  @override
  void initState() {
    super.initState();
    _initSDK();
    fetchTables();
  }

  // Inisialisasi Midtrans SDK
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
    print(
        'Transaction Details: ${result.transactionId}, ${result.paymentType}');
    _submitReservation(result);
  }

  // Menambahkan validasi dan data reservasi
  void _submitReservation(result) async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _tablePreference == null) {
      _showToast('Please fill all fields before submitting', true);
      return;
    }

    final transaction_id = result.transactionId;
    final transactionStatus = result.transactionStatus;
    final paymentType = result.paymentType;
    final orderId = result.orderId;

    final formattedDate =
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

    final id = DateTime.now().millisecondsSinceEpoch;

    final Map<String, dynamic> reservationData = {
      'id': id,
      'user_id': _authController.id.value,
      'name': _nameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'date': formattedDate,
      'time': _selectedTime ?? '',
      'guest_count': _guestCount,
      'table_id': _tablePreference,
      'transaction_id': transaction_id,
    };

    final Map<String, dynamic> transactionData = {
      'transaction_id': transaction_id,
      'transaction_status': 'settlement',
      'reservation_id': id,
      'payment_type': paymentType,
      'order_id': orderId,
      'status': 'sukses'
    };

    final response = await http.post(
      Uri.parse(baseUrl + '/reservations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reservationData),
    );

    if (response.statusCode == 201) {
      final response2 = await http.post(
        Uri.parse(baseUrl + '/payment/finish'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(transactionData),
      );
      _showToast('Reservation submitted successfully!', false);
    } else {
      _showToast('Failed to submit reservation: ${response.body}', true);
    }
  }

  // Menampilkan Toast
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
      body: SingleChildScrollView(
        child: Padding(
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

              // Pemilihan Tanggal
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
                  const Text('Select Time: '),
                  DropdownButton<String>(
                    value: _selectedTime,
                    hint: const Text('Choose Time Slot'),
                    items: availableTimes.map((String time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedTime = newValue;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Pemilihan Meja
              DropdownButton<String>(
                hint: Text('Select Table'),
                value: _tablePreference,
                items: tables.map((table) {
                  return DropdownMenuItem<String>(
                    value: table['id']
                        .toString(),
                    child: Text(table['table_number']),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _tablePreference = newValue;
                  });
                },
              ),

              SizedBox(height: 16),

              // Jumlah Tamu
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
      ),
    );
  }

  // Fungsi untuk memulai pembayaran
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
          }
        },
      );
    } catch (e) {
      _showToast('Error occurred during payment', true);
    }
  }
}
