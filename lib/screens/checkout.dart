import 'package:flutter/material.dart';
import 'package:flutter_retail_epson/services/native.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/barang.dart';
import '../models/pelanggan.dart';
import 'kasir.dart';

class Checkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NumberFormat _format = NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0);

    final _args = ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final List<Barang> keranjang = _args['keranjang'];
    final Pelanggan pelanggan = _args['pelanggan'];
    final total = _format.format(_args['total']);

    _convertData() {
      String data = "";
      for (var i = 0; i < keranjang.length; i++) {
        data += keranjang[i].nama + ",";
        data += keranjang[i].jumlah.toString() + "x @" + _format.format(int.parse(keranjang[i].harga)) + "&";
        data += _format.format(keranjang[i].jumlah * int.parse(keranjang[i].harga)).toString();
        if (i != keranjang.length - 1) {
          data += "|";
        }
      }
      print(data);
      return data;
    }

    print(keranjang);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          children: [
            Text('CHECKOUT'),
            Divider(),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: keranjang.length,
                itemBuilder: (context, index) => Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${keranjang[index].nama} (${keranjang[index].tipe})',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[Text('${keranjang[index].jumlah} X @${_format.format(int.parse(keranjang[index].harga))}'), Text('Rp. ${_format.format(keranjang[index].jumlah * int.parse(keranjang[index].harga))}')],
                      ),
                      SizedBox(height: 15)
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Alamat'),
                  Text(pelanggan.alamat),
                  SizedBox(height: 10),
                  const Text('Keterangan'),
                  Text(pelanggan.nama),
                  SizedBox(height: 10),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text('Total: '), Text('Rp. $total')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Consumer<NativeServices>(
                        builder: (context, nativeService, child) {
                          return RaisedButton.icon(
                            icon: Icon(Icons.print_outlined),
                            label: Text("Cetak Struk"),
                            color: Colors.blue,
                            onPressed: () async {
                              String target = nativeService.targetPrinter;
                              String items = _convertData();

                              Map<String, dynamic> data = {
                                "target": target,
                                "items": items,
                                "total": total,
                                "nama": pelanggan.nama,
                                "alamat": pelanggan.alamat,
                                "ket": pelanggan.keterangan,
                              };
                              await nativeService.checkout(data);
                            },
                          );
                        },
                      ),
                      RaisedButton.icon(
                        icon: Icon(Icons.check_box_outlined),
                        label: Text('Selesai'),
                        color: Colors.green,
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Kasir()), (route) => false);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
