import 'package:flutter/material.dart';
import '../services/token_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  PaymentState createState() => PaymentState();
}

class PaymentState extends State<Payment> {
  MidtransSDK? _midtrans;

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
    switch (result.transactionStatus) {
      case 'settlement':
        _handleSuccessfulTransaction(result);
        break;
      case 'pending':
        _handlePendingTransaction(result);
        break;
      case 'failed':
        _handleFailedTransaction(result);
        break;
      default:
        _showToast('Unhandled Transaction Status: ${result.transactionStatus}', true);
    }
  }

  void _handleSuccessfulTransaction(TransactionResult result) {
    _showToast('Transaction Completed Successfully', false);
    // Add any additional success handling logic here
    print('Transaction Details: ${result.transactionId}, ${result.paymentType}');
  }

  void _handlePendingTransaction(TransactionResult result) {
    _showToast('Transaction is Pending', true);
    // Consider implementing additional checks or server-side validation
  }

  void _handleFailedTransaction(TransactionResult result) {
    _showToast('Transaction Failed', true);
    // Log detailed error information
    print('Transaction Failure Details: ${result.transactionStatus}');
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Gateway'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: _initiatePayment,
            child: const Text("Pay Now"),
          ),
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
        }
      );
    } catch (e) {
      _showToast('Payment Initiation Error', true);
      print('Payment Error: $e');
    }
  }
}