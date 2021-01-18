import 'package:flutter/material.dart';

import '../../constant.dart';
import '../../services/database.dart';

class FormPelanggan extends StatefulWidget {
  @override
  _FormPelangganState createState() => _FormPelangganState();
}

class _FormPelangganState extends State<FormPelanggan> {
  final _formkey = GlobalKey<FormState>();
  String _currNama;
  String _currAlamat;
  String _currTelp;
  String _currKet;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        child: Column(
          children: [
            Text("Tambah Data Pelanggan Baru", style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            TextFormField(
              decoration: textInputDecoration.copyWith(
                  labelText: 'Nama Pelanggan',
                  suffixIcon: Icon(
                    Icons.account_box_outlined,
                    color: Colors.black,
                  )),
              onChanged: (val) => _currNama = val,
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: textInputDecoration.copyWith(
                  labelText: 'Alamat Pelanggan',
                  suffixIcon: Icon(
                    Icons.pin_drop_outlined,
                    color: Colors.black,
                  )),
              onChanged: (val) => _currAlamat = val,
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: textInputDecoration.copyWith(
                  labelText: 'Nomor Telp',
                  suffixIcon: Icon(
                    Icons.phone,
                    color: Colors.black,
                  )),
              onChanged: (val) => _currTelp = val,
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: textInputDecoration.copyWith(
                  labelText: 'Keterangan',
                  suffixIcon: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  )),
              onChanged: (val) => _currKet = val,
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Tambah'),
              onPressed: () async {
                await DatabaseService().addDataPelanggan(_currNama, _currAlamat, _currTelp, _currKet);
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }
}
