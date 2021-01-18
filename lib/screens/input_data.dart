import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../models/pelanggan.dart';
import '../services/database.dart';
import '../widgets/pelanggan/form_pelanggan.dart';
import '../widgets/pelanggan/pelanggan_item.dart';
import '../widgets/pelanggan/update_pelanggan.dart';

class InputDataWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamProvider.value(
        value: DatabaseService().pelanggans,
        child: InputData(),
      ),
    );
  }
}

class InputData extends StatefulWidget {
  @override
  _InputDataState createState() => _InputDataState();
}

class _InputDataState extends State<InputData> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final pelanggans = Provider.of<List<Pelanggan>>(context) ?? [];
    final tes = pelanggans.where((element) => element.nama.toLowerCase().contains(search)).toList();
    void _showInputPanel() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 50.0),
            child: FormPelanggan(),
          );
        },
      );
    }

    void _showUpdatePanel(Pelanggan pelanggan) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(15),
            child: UpdatePelanggan(pelanggan),
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          title: Text(
            'Input Data',
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
                  itemBuilder: (contex, index) => PelangganItem(tes[index], _showUpdatePanel),
                ),
              )
            ],
          ),
        ));
  }
}
