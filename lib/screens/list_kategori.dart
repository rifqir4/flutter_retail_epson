import 'package:flutter/material.dart';

import '../models/barang.dart';
import '../models/kategori.dart';
import '../services/database.dart';

class ListKategori extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
            stream: DatabaseService().kategoris,
            builder: (context, snapshot) {
              List<Kategori> listKategori = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Loading'),
                );
              } else {
                return GridView.builder(
                  itemCount: listKategori.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FlatButton(
                      onPressed: () async {
                        Barang barangs = await Navigator.of(context).pushNamed('/list-barang', arguments: listKategori[index].id).catchError((e) => print(e));
                        if (barangs != null) Navigator.of(context).pop(barangs);
                      },
                      child: Text(
                        listKategori[index].nama,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      color: Colors.blue[800],
                    ),
                  ),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                  ),
                );
              }
            }),
      ),
    );
  }
}
