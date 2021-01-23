import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/barang.dart';
import '../models/pelanggan.dart';
import '../widgets/belanja_item.dart';

class Kasir extends StatefulWidget {
  @override
  _KasirState createState() => _KasirState();
}

class _KasirState extends State<Kasir> {
  List<Barang> keranjang = [];
  Pelanggan pelanggan = Pelanggan(id: '123', nama: 'Rifqi Radifan', alamat: 'Jl. Ikan Piranha Atas', telp: '081334177037', keterangan: 'Didalem');
  int total = 0;

  final NumberFormat _format = NumberFormat.currency(locale: "id", symbol: "Rp. ", decimalDigits: 0);

  void addBarang(Barang barang) {
    int contain = keranjang.isNotEmpty ? keranjang.indexWhere((element) => element.id == barang.id) : null;
    if (contain != null && contain != -1) {
      setState(() {
        keranjang[contain].jumlah = keranjang[contain].jumlah + barang.jumlah;
        total = total + (int.parse(barang.harga) * barang.jumlah);
      });
    } else {
      setState(() {
        keranjang.add(barang);
        total = total + (int.parse(barang.harga) * barang.jumlah);
      });
    }
  }

  void deleteBarang(String id) {
    Barang barang = keranjang.where((element) => element.id == id).toList()[0];

    setState(() {
      total = total - int.parse(barang.harga) * barang.jumlah;
      keranjang.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  Widget buildContainerPelanggan(String title, String ket, Icon icon) {
    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.blue[200],
            child: icon,
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: 200,
              child: Text(
                ket,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Keranjang Belanja',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          FlatButton.icon(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
            icon: Icon(Icons.home_outlined),
            label: Text('Home'),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        buildContainerPelanggan(
                            'Alamat',
                            pelanggan.alamat,
                            Icon(
                              Icons.place_outlined,
                              color: Colors.white,
                            )),
                        SizedBox(height: 12),
                        buildContainerPelanggan(
                          'Keterangan',
                          pelanggan.nama,
                          Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 30,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed('/list-pelanggan').then((value) {
                                  if (value != null) setState(() => pelanggan = value);
                                }),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/list-kategori').catchError((e) => print(e)).then(
                        (newBarang) {
                          if (newBarang != null) addBarang((newBarang as Barang) ?? []);
                        },
                      );
                    },
                    color: Colors.green,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Tambah Barang Baru",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        itemCount: keranjang.length,
                        itemBuilder: (context, index) => BelanjaItem(keranjang[index], deleteBarang),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[Text('Total:'), Text(_format.format(total))],
                      ),
                    ),
                    RaisedButton.icon(
                        onPressed: () {
                          keranjang.length != 0
                              ? Navigator.of(context).pushNamed('/checkout', arguments: {'keranjang': keranjang, 'pelanggan': pelanggan, 'total': total})
                              : showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Peringatan !!"),
                                    content: Text("Keranjang Masih Kosong"),
                                  ),
                                );
                        },
                        icon: Icon(Icons.shopping_cart_outlined),
                        label: Text('Selesaikan Pembelanjaan'))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
