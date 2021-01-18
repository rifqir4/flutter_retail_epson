import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/barang.dart';
import '../models/kategori.dart';
import '../models/pelanggan.dart';

class DatabaseService {
  final CollectionReference barangCollection = FirebaseFirestore.instance.collection('barang');
  final CollectionReference pelangganCollection = FirebaseFirestore.instance.collection('pelanggan');
  final CollectionReference kategoriCollection = FirebaseFirestore.instance.collection('kategori');

  List<Barang> _barangListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Barang(
        id: doc.id,
        nama: doc.data()['nama'] ?? '',
        harga: doc.data()['harga'] ?? '0',
        tipe: doc.data()['tipe'] ?? '',
        kategori: doc.data()['kategori'] ?? '',
        image: doc.data()['image'] ?? '',
        jumlah: doc.data()['jumlah'] ?? 0,
      );
    }).toList();
  }

  Stream<List<Barang>> get barangs {
    return barangCollection.snapshots().map(_barangListFromSnapshot);
  }

  //add data barang
  Future addDataBarang(String nama, String harga, String tipe, String kategori, String image, int jumlah, bool katStat) async {
    if (katStat) await kategoriCollection.add({'nama': kategori});
    return await barangCollection.add({'nama': nama, 'harga': harga, 'tipe': tipe, 'kategori': kategori, 'image': image, 'jumlah': jumlah});
  }

  Future deleteDataBarang(String id) async {
    await barangCollection.doc(id).delete();
  }

  Future updateDataBarang(String id, String nama, String harga, String tipe, String kategori) async {
    return await barangCollection.doc(id).set({'nama': nama, 'harga': harga, 'tipe': tipe, 'kategori': kategori});
  }

  List<Pelanggan> _pelangganListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Pelanggan(
        id: doc.id,
        nama: doc.data()['nama'] ?? '',
        alamat: doc.data()['alamat'] ?? '',
        telp: doc.data()['telp'] ?? '',
        keterangan: doc.data()['keterangan'] ?? '',
      );
    }).toList();
  }

  Stream<List<Pelanggan>> get pelanggans {
    return pelangganCollection.snapshots().map(_pelangganListFromSnapshot);
  }

  Future addDataPelanggan(String nama, String alamat, String telp, String keterangan) async {
    return await pelangganCollection.add({
      'nama': nama,
      'alamat': alamat,
      'telp': telp,
      'keterangan': keterangan,
    });
  }

  Future deleteDataPelanggan(String id) async {
    await pelangganCollection.doc(id).delete();
  }

  Future updateDataPelanggan(String id, String nama, String alamat, String telp, String keterangan) async {
    return await pelangganCollection.doc(id).set({'nama': nama, 'alamat': alamat, 'telp': telp, 'keterangan': keterangan});
  }

  List<Kategori> _kategoriListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Kategori(id: doc.id, nama: doc.data()['nama'] ?? '');
    }).toList();
  }

  Stream<List<Kategori>> get kategoris {
    return kategoriCollection.snapshots().map(_kategoriListFromSnapshot);
  }
}
