class AlumniModel {
  final String nama;
  final String nim;
  final String? email;
  final String prodi;
  final String jurusan;
  final String angkatan;
  final String tempatLahir;
  final String tanggalLahir;
  final String tahunLulus;
  final String? alamat;

  AlumniModel({
    required this.nama,
    required this.nim,
    this.email,
    required this.prodi,
    required this.jurusan,
    required this.angkatan,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.tahunLulus,
    this.alamat,
  });

  factory AlumniModel.fromJson(Map<String, dynamic> json) {
    return AlumniModel(
      nama: json['nama'],
      nim: json['nim'],
      email: json['email'],
      prodi: json['prodi'],
      jurusan: json['jurusan'],
      angkatan: json['angkatan'].toString(),
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
      tahunLulus: json['tahun_lulus'].toString(),
      alamat: json['alamat'],
    );
  }
}