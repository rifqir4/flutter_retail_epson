import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/barang.dart';
import '../../services/database.dart';
import '../../widgets/barang/form_barang.dart';
import '../../widgets/barang/update_barang.dart';

class GetKategori extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: DatabaseService().kategoris,
      child: FormBarang(),
    );
  }
}

class GetKategoriUpdate extends StatelessWidget {
  final Barang barang;
  GetKategoriUpdate(this.barang);
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: DatabaseService().kategoris,
      child: UpdateBarang(barang),
    );
  }
}
