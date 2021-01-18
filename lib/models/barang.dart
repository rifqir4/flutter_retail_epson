import 'package:flutter/foundation.dart';

class Barang {
  final String id;
  String nama;
  String tipe;
  String harga;
  String kategori;
  String image;
  int jumlah;

  Barang(
      {@required this.id,
      @required this.nama,
      @required this.harga,
      @required this.tipe,
      @required this.kategori,
      @required this.image,
      this.jumlah});
}
