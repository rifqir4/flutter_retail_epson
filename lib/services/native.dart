import 'package:flutter/services.dart';

class NativeServices {
  static const MethodChannel _channel = const MethodChannel('com.example.flutter_retail_epson');

  Future<String> discoverPrinter() async {
    String response = await _channel.invokeMethod('discoverPrinter');
    return response;
  }

  Future checkout() async {
    var response = await _channel.invokeMethod('checkout');
    return response;
  }
}
