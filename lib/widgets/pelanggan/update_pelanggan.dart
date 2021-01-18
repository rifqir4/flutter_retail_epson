import 'package:flutter/material.dart';

import '../../constant.dart';
import '../../models/pelanggan.dart';
import '../../services/database.dart';

class UpdatePelanggan extends StatefulWidget {
  final Pelanggan pelanggan;
  UpdatePelanggan(this.pelanggan);
  @override
  _UpdatePelangganState createState() => _UpdatePelangganState();
}

class _UpdatePelangganState extends State<UpdatePelanggan> {
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
            Text("Edit Data Pelanggan", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            TextFormField(
              initialValue: widget.pelanggan.nama,
              decoration: textInputDecoration.copyWith(hintText: 'Nama Pelanggan'),
              onChanged: (val) => setState(() => _currNama = val),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: widget.pelanggan.alamat,
              decoration: textInputDecoration.copyWith(hintText: 'Alamat Pelanggan'),
              onChanged: (val) => setState(() => _currAlamat = val),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: widget.pelanggan.telp,
              decoration: textInputDecoration.copyWith(hintText: 'Nomor Telp'),
              onChanged: (val) => setState(() => _currTelp = val),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: widget.pelanggan.keterangan,
              decoration: textInputDecoration.copyWith(hintText: 'Keterangan'),
              onChanged: (val) => setState(() => _currKet = val),
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Update'),
              onPressed: () {
                DatabaseService().updateDataPelanggan(widget.pelanggan.id, _currNama ?? widget.pelanggan.nama, _currAlamat ?? widget.pelanggan.alamat, _currTelp ?? widget.pelanggan.telp, _currKet ?? widget.pelanggan.keterangan);
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }
}
