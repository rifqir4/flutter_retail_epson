import 'package:flutter/material.dart';

import '../models/barang.dart';

class BelanjaItem extends StatelessWidget {
  final Barang barang;
  final dynamic delete;
  BelanjaItem(this.barang, this.delete);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(barang.nama),
                Row(
                  children: [Icon(Icons.circle, size: 10, color: Colors.green[500]), Text(' ${barang.tipe}', style: TextStyle(color: Colors.green[500]))],
                ),
              ],
            ),
            Text('Rp. ${barang.harga}'),
            Row(
              children: <Widget>[Icon(Icons.shopping_bag_outlined), Text(' ${barang.jumlah ?? 0}')],
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Container(
                padding: EdgeInsets.all(2),
                color: Colors.red[100],
                child: InkWell(
                  onTap: () {
                    delete(barang.id);
                  },
                  child: Icon(Icons.delete_outline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
