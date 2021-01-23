import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_retail_epson/services/native.dart';
import 'package:provider/provider.dart';
import './screens/checkout.dart';
import './screens/home.dart';
import './screens/input_barang.dart';
import './screens/input_data.dart';
import './screens/kasir.dart';
import './screens/list_barang.dart';
import './screens/list_kategori.dart';
import './screens/list_pelanggan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<NativeServices>(
      create: (context) => NativeServices(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.black,
          accentColor: Colors.blue[200],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/kasir': (context) => Kasir(),
          '/input-barang': (context) => InputBarangWrapper(),
          '/input-data': (context) => InputDataWrapper(),
          '/checkout': (context) => Checkout(),
          '/list-barang': (context) => ListBarangWrapper(),
          '/list-pelanggan': (context) => ListPelangganWrapper(),
          '/list-kategori': (context) => ListKategori(),
        },
      ),
    );
  }
}
