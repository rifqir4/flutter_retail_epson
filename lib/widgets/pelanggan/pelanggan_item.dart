import 'package:flutter/material.dart';

import '../../models/pelanggan.dart';
import '../../services/database.dart';

class PelangganItem extends StatelessWidget {
  final Pelanggan pelanggan;
  final dynamic showUpdate;
  PelangganItem(this.pelanggan, this.showUpdate);

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
              children: <Widget>[Text(pelanggan.nama), SizedBox(height: 10), Text(pelanggan.alamat), SizedBox(height: 5), Text(pelanggan.telp)],
            ),
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Container(
                    padding: EdgeInsets.all(2),
                    color: Colors.green[100],
                    child: InkWell(
                      onTap: () {
                        showUpdate(pelanggan);
                      },
                      child: Icon(Icons.edit_outlined),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Container(
                    padding: EdgeInsets.all(2),
                    color: Colors.red[100],
                    child: InkWell(
                      onTap: () {
                        DatabaseService().deleteDataPelanggan(pelanggan.id);
                      },
                      child: Icon(Icons.delete_outline),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
