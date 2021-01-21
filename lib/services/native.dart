import 'package:flutter/services.dart';

class NativeServices {
  static const MethodChannel _channel = const MethodChannel('com.example.flutter_retail_epson');
  String _targetPrinter = "tes";

  String get targetPrinter => _targetPrinter;

  Future<void> discoverPrinter() async {
    String response = await _channel.invokeMethod('discoverPrinter');
    _targetPrinter = response;
  }

  Future checkout(Map<String, dynamic> map) async {
    var response = await _channel.invokeMethod('checkout', map);
    _targetPrinter = response;
  }
}
