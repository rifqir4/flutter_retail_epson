import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../models/barang.dart';
import '../../models/kategori.dart';
import '../../services/database.dart';

class UpdateBarang extends StatefulWidget {
  final Barang barang;
  UpdateBarang(this.barang);
  @override
  _UpdateBarangState createState() => _UpdateBarangState();
}

class _UpdateBarangState extends State<UpdateBarang> {
  final _formkey = GlobalKey<FormState>();
  String _currNama;
  String _currHarga;
  String _currTipe;
  String _currKategori;

  @override
  Widget build(BuildContext context) {
    List<Kategori> kategorisku = Provider.of<List<Kategori>>(context);

    List<DropdownMenuItem> _buildDropdownItem(snapshot) {
      List<DropdownMenuItem> kategori = [];
      List<Kategori> kategoris = snapshot;
      for (var i = 0; i < kategoris.length; i++) {
        kategori.add(DropdownMenuItem(value: kategoris[i].id.toString(), child: Text(kategoris[i].nama)));
      }
      return kategori;
    }

    if (kategorisku != null) {
      if (_currKategori == null) _currKategori = widget.barang.kategori;

      return Form(
          key: _formkey,
          child: Column(
            children: [
              Text("Edit Barang", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              TextFormField(
                initialValue: widget.barang.nama,
                decoration: textInputDecoration.copyWith(hintText: 'Nama Barang'),
                onChanged: (val) => setState(() => _currNama = val),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: widget.barang.harga,
                decoration: textInputDecoration.copyWith(hintText: 'Harga'),
                onChanged: (val) => setState(() => _currHarga = val),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: textInputDecoration,
                value: _currKategori,
                items: _buildDropdownItem(kategorisku),
                onChanged: (val) {
                  setState(() => _currKategori = val);
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: textInputDecoration,
                value: _currTipe ?? widget.barang.tipe,
                items: <DropdownMenuItem>[
                  DropdownMenuItem(value: 'Eceran', child: Text('Eceran')),
                  DropdownMenuItem(value: 'Grosir', child: Text('Grosir')),
                ],
                onChanged: (val) {
                  setState(() => _currTipe = val);
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    child: Text('Cancel'),
                    color: Colors.red[100],
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text('Update'),
                    onPressed: () async {
                      // update(barang.id, _currNama ?? barang.nama,
                      //     _currHarga ?? barang.harga, _currTipe ?? barang.tipe);
                      await DatabaseService().updateDataBarang(widget.barang.id, _currNama ?? widget.barang.nama, _currHarga ?? widget.barang.harga, _currTipe ?? widget.barang.tipe, _currKategori ?? widget.barang.kategori);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ));
    } else {
      return Container(
        child: Text('Loading'),
      );
    }
  }
}
