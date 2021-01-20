import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/barang.dart';
import '../services/database.dart';

class ListBarangWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String kategori = ModalRoute.of(context).settings.arguments as String;
    return Container(
      child: StreamProvider.value(
        value: DatabaseService().barangs,
        child: ListBarang(kategori),
      ),
    );
  }
}

class ListBarang extends StatefulWidget {
  final String kategori;
  ListBarang(this.kategori);
  @override
  _ListBarangState createState() => _ListBarangState();
}

class _ListBarangState extends State<ListBarang> {
  // final barangs = DATA_BARANGS;

  int jumlah = 1;
  NumberFormat _format = NumberFormat.currency(locale: "id", symbol: "Rp. ", decimalDigits: 0);

  _createAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (contex) => StatefulBuilder(builder: (context, setState) {
        _countHandle(bool stat) {
          if (stat) {
            setState(() => jumlah = jumlah + 1);
          } else if (jumlah != 0) {
            setState(() => jumlah = jumlah - 1);
          }
        }

        return AlertDialog(
          title: Text('Masukkan Jumlah yang Diinginkan'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () => _countHandle(false),
                child: Container(
                  padding: EdgeInsets.all(2),
                  child: Icon(Icons.remove),
                ),
              ),
              Text('$jumlah'),
              InkWell(
                onTap: () => _countHandle(true),
                child: Container(
                  padding: EdgeInsets.all(2),
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
          actions: [
            MaterialButton(
              elevation: 5,
              child: Text('Tambahkan Data'),
              onPressed: () {
                String tes = 'haihai';
                Navigator.of(context).pop(tes);
              },
            )
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.kategori);
    List<Barang> barangsFull = Provider.of<List<Barang>>(context);
    List<Barang> barangs = barangsFull != null ? barangsFull.where((element) => element.kategori == widget.kategori).toList() : [];

    return Scaffold(
      body: barangs != null
          ? Container(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: barangs.length ?? 0,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () async {
                          // print(barangs[index]);
                          // Navigator.of(context).pop(barangs[index]);
                          dynamic poo = await _createAlertDialog(context);
                          if (poo != null) {
                            setState(() {
                              barangs[index].jumlah = jumlah;
                            });
                            Navigator.of(context).pop(barangs[index]);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                barangs[index].nama,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[Text('${_format.format(int.parse(barangs[index].harga))}'), Text('Tipe: ${barangs[index].tipe}')],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    child: Text('Kembali'),
                  )
                ],
              ),
            )
          : Center(child: Text("Loading..")),
    );
  }
}
