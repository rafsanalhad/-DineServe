class ListReservasi{
  String id;
  String nama;
  String tgl;
  String jam;
  String status;

  ListReservasi({this.id = '', this.nama= '', this.tgl='', this.jam='', this.status=''});

  factory ListReservasi.fromJson(Map<String, dynamic> json){
    return ListReservasi(
      id: json['id'],
      nama: json['nama'],
      tgl: json['tgl'],
      jam: json['jam'],
      status: json['status'],
    );
  }
}