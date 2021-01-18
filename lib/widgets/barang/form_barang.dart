import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../models/kategori.dart';
import '../../services/database.dart';

class FormBarang extends StatefulWidget {
  @override
  _FormBarangState createState() => _FormBarangState();
}

class _FormBarangState extends State<FormBarang> {
  final _formkey = GlobalKey<FormState>();
  String _currNama;
  String _currHarga;
  String _currTipe = 'Eceran';
  String _currKategori;
  bool _checkbox = false;

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
      if (_currKategori == null) _currKategori = kategorisku[0].id;
      return Form(
          key: _formkey,
          child: Column(
            children: [
              Text("Tambah Barang Baru", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                    labelText: 'Nama Barang',
                    suffixIcon: Icon(
                      Icons.featured_play_list_outlined,
                      color: Colors.black,
                    )),
                onChanged: (val) => _currNama = val,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                    labelText: 'Harga',
                    suffixIcon: Icon(
                      Icons.attach_money_outlined,
                      color: Colors.black,
                    )),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (val) => _currHarga = val,
              ),
              SizedBox(height: 10),
              if (_checkbox)
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Kategori',
                      suffixIcon: Icon(
                        Icons.category_outlined,
                        color: Colors.black,
                      )),
                  onChanged: (val) => _currKategori = val,
                ),
              if (!_checkbox)
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currKategori,
                  items: _buildDropdownItem(kategorisku),
                  onChanged: (val) {
                    setState(() => _currKategori = val);
                  },
                ),
              Row(
                children: [
                  Checkbox(
                      value: _checkbox,
                      onChanged: (val) {
                        setState(() => _checkbox = val);
                        _currKategori = null;
                      }),
                  Text('Tambah Kategori Baru?'),
                ],
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: textInputDecoration,
                value: _currTipe ?? 'Eceran',
                items: <DropdownMenuItem>[
                  DropdownMenuItem(value: 'Eceran', child: Text('Eceran')),
                  DropdownMenuItem(value: 'Grosir', child: Text('Grosir')),
                ],
                onChanged: (val) {
                  setState(() => _currTipe = val);
                },
              ),
              SizedBox(height: 20),
              RaisedButton(
                child: Text('Tambah'),
                onPressed: () {
                  //addBarang(_currNama, _currHarga, _currTipe ?? 'Eceran');
                  DatabaseService().addDataBarang(_currNama, _currHarga, _currTipe, _currKategori, 'adada', 0, _checkbox);
                  Navigator.pop(context);
                },
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
