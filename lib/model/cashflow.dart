// ignore_for_file: unnecessary_this

class Cashflow {
  late int id;
  late String _tanggal;
  late int _nominal;
  late String _keterangan;
  late String _tipe;

  Cashflow(this._tanggal, this._nominal, this._keterangan, this._tipe);

  Cashflow.map(dynamic obj) {
    this._tanggal = obj['tanggal'];
    this._nominal = obj['nominal'];
    this._keterangan = obj['keterangan'];
    this._tipe = obj['tipe'];
  }

  String get tanggal => _tanggal;
  int get nominal => _nominal;
  String get keterangan => _keterangan;
  String get tipe => _tipe;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['tanggal'] = _tanggal;
    map['nominal'] = _nominal;
    map['keterangan'] = _keterangan;
    map['tipe'] = _tipe;
    return map;
  }

  void setCashflowId(int id) {
    this.id = id;
  }
}
