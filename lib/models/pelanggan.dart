import 'package:flutter/foundation.dart';

class Pelanggan {
  final String id;
  String nama;
  String alamat;
  String telp;
  String keterangan;

  Pelanggan(
      {@required this.id,
      @required this.nama,
      @required this.alamat,
      @required this.telp,
      @required this.keterangan});
}
