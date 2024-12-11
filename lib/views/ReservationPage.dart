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
              .map((table) =>
                  {'id': table['id'], 'table_number': table['table_number']})
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

    // Membuat Map untuk data reservasi
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

    final response = await http.post(
      Uri.parse(baseUrl + '/reservations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reservationData),
    );

    if (response.statusCode == 201) {
      // Menyelesaikan pembayaran setelah reservasi berhasil
      final Map<String, dynamic> transactionData = {
        'transaction_id': transaction_id,
        'transaction_status': 'settlement',
        'reservation_id': id,
        'payment_type': paymentType,
        'order_id': orderId,
        'status': 'sukses',
      };

      final response2 = await http.post(
        Uri.parse(baseUrl + '/payment/finish'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(transactionData),
      );
      _showConfirmationDialog();
    } else {
      _showToast('Maaf anda belum bayar', true);
    }
  }

  bool _isDialogShowing = false;

  void _showConfirmationDialog() {
    if (!_isDialogShowing) {
      _isDialogShowing = true;
      showDialog(
        context: context,
        barrierDismissible:
            false, // Tidak bisa menutup dialog dengan klik di luar dialog
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              _isDialogShowing = false;
              return true;
            },
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20), // Membuat sudut lebih bulat
              ),
              elevation: 10, // Memberikan efek shadow pada dialog
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 80.0,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Reservation Submitted',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Your reservation has been successfully submitted.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _isDialogShowing = false;
                        Navigator.of(context).pop(); // Tutup dialog
                        Navigator.pushReplacementNamed(context, '/history');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ).then((_) {
        _isDialogShowing = false;
      }).catchError((_) {
        _isDialogShowing = false;
      });
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
        title: const Text('Reservasi dan Pembayaran'),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Atas Nama',
                  labelStyle: TextStyle(color: Colors.black87),
                  filled: true, // Mengaktifkan background
                  fillColor: Colors.grey[200], // Warna background
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  // Menghilangkan border
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Mengatur border radius
                    borderSide: BorderSide.none, // Menghilangkan border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Mengatur border radius
                    borderSide:
                        BorderSide.none, // Menghilangkan border saat fokus
                  ),
                ),
              ),
              SizedBox(height: 16),

// Phone Number
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'No Telp',
                  labelStyle: TextStyle(color: Colors.black87),
                  filled: true, // Mengaktifkan background
                  fillColor: Colors.grey[200], // Warna background
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  // Menghilangkan border
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Mengatur border radius
                    borderSide: BorderSide.none, // Menghilangkan border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Mengatur border radius
                    borderSide:
                        BorderSide.none, // Menghilangkan border saat fokus
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),

// Email Address
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black87),
                  filled: true, // Mengaktifkan background
                  fillColor: Colors.grey[200], // Warna background
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  // Menghilangkan border
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Mengatur border radius
                    borderSide: BorderSide.none, // Menghilangkan border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Mengatur border radius
                    borderSide:
                        BorderSide.none, // Menghilangkan border saat fokus
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 16),

              // Date Selection
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
                    child: const Text('Pilih Tanggal'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      backgroundColor: Color(0xFF18654A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(_selectedDate == null
                      ? 'Tanggal belum dipilih'
                      : '${_selectedDate!.toLocal()}'.split(' ')[0]),
                ],
              ),
              SizedBox(height: 16),

              // Time Selection
              Row(
                children: [
                  const Text('Pilih Jam: '),
                  DropdownButton<String>(
                    value: _selectedTime,
                    hint: const Text('Pilih Slot Waktu'),
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

              const Text('Pilih Meja: '),
              DropdownButton<String>(
                hint: Text('Pilih Meja'),
                value: _tablePreference,
                items: tables.map((table) {
                  return DropdownMenuItem<String>(
                    value: table['id'].toString(),
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

              // Guest Count
              Row(
                children: [
                  const Text('Jumlah Orang: '),
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
              SizedBox(height: 32),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _initiatePayment,
                  child: const Text('Lakukan Pembayaran'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    backgroundColor: Color(0xFF18654A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

  void _initiatePayment() async {
    // Mengecek apakah reservasi sudah ada di waktu dan meja yang sama
    final formattedDate =
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
    final checkResponse = await http.post(
      Uri.parse(baseUrl + '/check_reservation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'date': formattedDate,
        'time': _selectedTime,
        'table_id': _tablePreference,
      }),
    );

    if (checkResponse.statusCode != 200) {
      // Jika ada konflik reservasi
      final responseJson = jsonDecode(checkResponse.body);
      _showToast(responseJson['message'], true);
      return;
    }

    // Jika tidak ada konflik, lanjutkan dengan reservasi
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
