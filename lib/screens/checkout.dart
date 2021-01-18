import 'package:flutter/material.dart';

import '../models/barang.dart';
import '../models/pelanggan.dart';
import 'kasir.dart';

class Checkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _args = ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final List<Barang> keranjang = _args['keranjang'];
    final Pelanggan pelanggan = _args['pelanggan'];
    final total = _args['total'];

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
                        children: <Widget>[Text('${keranjang[index].jumlah} X @${keranjang[index].harga}'), Text('Rp. ${(keranjang[index].jumlah * int.parse(keranjang[index].harga))}')],
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
                  Text('Alamat'),
                  Text(pelanggan.alamat),
                  SizedBox(height: 10),
                  Text('Keterangan'),
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
                      RaisedButton.icon(
                        icon: Icon(Icons.print_outlined),
                        label: Text('Cetak Struk'),
                        color: Colors.blue,
                        onPressed: () {},
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
