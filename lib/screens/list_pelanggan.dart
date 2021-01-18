import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pelanggan.dart';
import '../services/database.dart';

class ListPelangganWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamProvider.value(
        value: DatabaseService().pelanggans,
        child: ListPelanggan(),
      ),
    );
  }
}

class ListPelanggan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pelanggans = Provider.of<List<Pelanggan>>(context);

    return Scaffold(
      body: pelanggans != null
          ? Container(
              child: ListView.builder(
                itemCount: pelanggans.length,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.all(15),
                  height: 50,
                  decoration: BoxDecoration(color: Colors.blue[200], border: Border.all(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(pelanggans[index]);
                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${pelanggans[index].nama}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Center(child: Text('Loading')),
    );
  }
}
