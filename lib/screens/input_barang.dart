import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/barang.dart';
import '../services/database.dart';
import '../widgets/barang/barang_item.dart';
import '../widgets/barang/get_kategori.dart';

import '../constant.dart';

class InputBarangWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamProvider.value(
        value: DatabaseService().barangs,
        child: InputBarang(),
      ),
    );
  }
}

class InputBarang extends StatefulWidget {
  @override
  _InputBarangState createState() => _InputBarangState();
}

class _InputBarangState extends State<InputBarang> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final barangs = Provider.of<List<Barang>>(context) ?? [];
    final tes = barangs.where((element) => element.nama.toLowerCase().contains(search)).toList();
    void _showInputPanel() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 50.0),
            child: GetKategori(),
          );
        },
      );
    }

    void _showUpdatePanel(Barang barang) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(15),
            child: GetKategoriUpdate(barang),
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          title: Text(
            'Input Barang',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            FlatButton.icon(
              onPressed: () => _showInputPanel(),
              icon: Icon(Icons.add),
              label: Text('Tambah'),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: textSearchDecoration.copyWith(hintText: 'Search'),
                onChanged: (val) => setState(() => search = val),
              ),
              SizedBox(height: 10),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: tes.length,
                  itemBuilder: (contex, index) => BarangItem(tes[index], _showUpdatePanel),
                ),
              )
            ],
          ),
        ));
  }
}
