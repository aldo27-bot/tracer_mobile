class AlumniModel {

  String? nim;
  String? nama;
  String? tanggalLahir;
  String? tahunLulus;
  String? prodi;

  AlumniModel({
    this.nim,
    this.nama,
    this.tanggalLahir,
    this.tahunLulus,
    this.prodi
  });

  factory AlumniModel.fromJson(Map<String, dynamic> json) {
    return AlumniModel(
      nim: json['nim'],
      nama: json['nama'],
      tanggalLahir: json['tanggal_lahir'],
      tahunLulus: json['tahun_lulus'],
      prodi: json['prodi'],
    );
  }

}