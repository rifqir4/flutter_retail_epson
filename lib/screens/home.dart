import 'package:flutter/material.dart';
import 'dart:io';

import '../models/menu.dart';
import '../widgets/menu_item.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final menu = [
    Menu(route: '/kasir', title: 'Kasir', image: 'assets/images/giveaway.png'),
    Menu(route: '/input-barang', title: 'Input Barang', image: 'assets/images/newsletter.png'),
    Menu(route: '/input-data', title: 'Input Data Pelanggan', image: 'assets/images/data.png'),
  ];

  bool connection = false;
  bool connectionIsChecked = false;

  Future<void> _checkconnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      print("Connected");
      connection = true;
    } on SocketException catch (_) {
      print('not connected');
      connection = false;
    }
    setState(() {
      connectionIsChecked = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkconnection();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(connection);
    return connection
        ? Scaffold(
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30),
                  Container(
                    width: 300,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.place_outlined),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Jl. Kasuari Raya No. 256 Perumnas 1, Kayuringin Jaya, Bekasi Selatan, Kota Bekasi, 17144',
                                style: TextStyle(fontSize: 20),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.phone_outlined),
                            SizedBox(width: 6),
                            Text(
                              '021-8868068',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: menu.length,
                      itemBuilder: (context, index) => MenuItem(
                        title: menu[index].title,
                        image: menu[index].image,
                        route: menu[index].route,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    connectionIsChecked
                        ? {
                            Text('No Internet Connection'),
                            RaisedButton(
                              onPressed: () {
                                _checkconnection();
                              },
                              child: Text('Refresh'),
                            )
                          }
                        : Text('Loading'),
                  ],
                ),
              ),
            ),
          );
  }
}
