# Personal Portfolio Mobile - PBP

Repositori ini berisi proyek **MyPortfolio Mobile**, aplikasi portofolio pribadi berbasis Flutter dan Dart yang dikembangkan untuk mata kuliah **Pemrograman Berbasis Platform (CSGE602022)**, Fakultas Ilmu Komputer, Universitas Indonesia.

* **Nama:** Jonathan Sebastian Sindhu
* **NPM:** 2506619650
* **Kelas:** PBP B / Gasal 2026/2027

---

## 🚀 Panduan Menjalankan Proyek Secara Lokal

Pastikan Anda telah menginstal Git dan Flutter SDK yang menyertakan Dart **>= 3.13.7 dan < 4.0.0**, sesuai dengan konfigurasi pada `pubspec.yaml`. Tambahkan direktori `flutter/bin` ke `PATH`; Dart SDK sudah disertakan dalam Flutter SDK.

Siapkan **Google Chrome** sebagai target eksekusi awal. Untuk menjalankan aplikasi di Android, siapkan Android Studio beserta Android SDK, Command-line Tools, Build-Tools, dan Platform-Tools, lalu gunakan emulator Android atau perangkat fisik dengan USB debugging aktif. Anda dapat menggunakan VS Code dengan ekstensi Flutter dan Dart sebagai editor.

1. **Kloning Repositori:**
   ```bash
   git clone https://github.com/Kobaneru/myportofolio_mobile.git
   cd myportofolio_mobile
   ```

2. **Periksa Konfigurasi Flutter:**
   ```bash
   flutter --version
   flutter doctor
   ```
   Selesaikan konfigurasi yang diperlukan untuk platform tujuan berdasarkan hasil pemeriksaan tersebut.

   Jika memilih Android dan lisensinya belum disetujui, jalankan:
   ```bash
   flutter doctor --android-licenses
   ```
   Ikuti proses persetujuan lisensi, lalu periksa kembali dengan `flutter doctor`.

3. **Instal Dependensi:**
   ```bash
   flutter pub get
   ```

4. **Jalankan Aplikasi Flutter:**
   Periksa perangkat yang tersedia dan pastikan Chrome terdeteksi:
   ```bash
   flutter devices
   ```
   Jalankan aplikasi di Google Chrome:
   ```bash
   flutter run -d chrome
   ```
   Sebagai alternatif, nyalakan emulator Android atau hubungkan perangkat fisik, lalu jalankan `flutter run -d <device_id>` menggunakan ID dari hasil `flutter devices`.

5. **Periksa Kualitas Kode:**
   ```bash
   flutter analyze
   ```

---

## 📌 Log Perkembangan Proyek

### Minggu 11 (Tutorial 08 & Individual Assignment 7)
* Mengembangkan aplikasi `myportofolio_mobile` berbasis Flutter dan Dart sebagai antarmuka mobile portofolio pribadi, melanjutkan fondasi Tutorial 08 untuk Tugas 7.
* Memisahkan titik masuk dan konfigurasi aplikasi pada `lib/main.dart` dari halaman utama serta komponen antarmuka pada `lib/menu.dart`.
* Menggunakan `StatelessWidget` untuk `MyApp`, `MyHomePage`, `InfoCard`, dan `ItemCard`, serta mengatur tema Material 3 dengan warna dasar indigo dan warna sekunder amber.
* Menampilkan identitas pemilik (NPM, nama lengkap, dan kelas PBP) melalui tiga komponen `InfoCard` yang disusun secara horizontal.
* Menyusun halaman utama menggunakan `Scaffold`, `AppBar`, `Padding`, `Column`, dan `Row`, serta menampilkan pesan sambutan dan menu dalam `GridView.count` dengan tiga kolom.
* Mendefinisikan model `ItemHomepage` dengan atribut nama, ikon, dan warna untuk membuat tombol **Lihat Pengalaman** (biru), **Tambah Pengalaman** (hijau), dan **Logout** (merah).
* Mengimplementasikan respons sentuhan melalui `InkWell` dan `ScaffoldMessenger` untuk menampilkan SnackBar bertuliskan “Kamu telah menekan tombol [Nama Tombol]!”. Pada tahap ini, ketiga tombol memberikan umpan balik SnackBar; navigasi, penambahan data, autentikasi, dan integrasi REST API Django belum diimplementasikan.

---

### Tugas 7

1. Pada Flutter, widget tree adalah representasi logika dari semua susunan widget tampilan. Flutter menggunakan element tree untuk mengelola instans widget dan render tree untuk layout, painting, serta hit testing. Dalam tree, setiap node merepresentasikan widget yang konfigurasinya bersifat immutable. Pada StatefulWidget, state yang dapat berubah dikelola melalui objek State terpisah. Widget bisa memiliki hubungan dengan parent atau childnya, seperti Scaffold dengan AppBar. Setiap perubahan yang terjadi pada state bisa menyebabkan rebuild pada widget yang bersangkutan dan widget anak-anaknya yang diperlukan.

2. Terdapat beberapa widget yang saya gunakan dalam proyek kali ini yang terbagi menjadi widget kustom dan bawaan Flutter yaitu sebagai berikut.

   Widget Kustom:
   * MyApp (turunan StatelessWidget) berfungsi sebagai root widget aplikasi yang dijalankan pertama kali oleh fungsi runApp(), bertugas mengatur konfigurasi tema global (indigo & amber) dan menentukan halaman awal aplikasi (MyHomePage).
   * MyHomePage (turunan StatelessWidget) berfungsi sebagai widget halaman utama (home screen) yang menyusun keseluruhan tampilan antarmuka awal, mulai dari bilah judul, kartu informasi profil (NPM, Nama, Kelas), pesan sambutan, hingga kisi tombol menu portofolio.
   * InfoCard (turunan StatelessWidget) berfungsi sebagai widget kartu yang dapat digunakan kembali (reusable) untuk menampilkan pasangan informasi singkat berupa judul (title) dan isi data (content) secara vertikal di dalam kotak berbayang.
   * ItemCard (turunan StatelessWidget) berfungsi sebagai widget tombol interaktif berbentuk kartu berwarna yang merepresentasikan setiap item menu pada GridView, lengkap dengan ikon, label teks, dan respons sentuhan untuk menampilkan SnackBar.
   
      Nb: ItemHomepage merupakan model data, bukan widget.

   Widget Bawaan Flutter:
   * MaterialApp berfungsi untuk membungkus seluruh aplikasi dengan sistem desain Material Design, mengatur tema warna global (ThemeData), judul aplikasi (MyPortfolio), serta sistem navigasi dan rute awal (home).
   * Scaffold berfungsi untuk menyediakan kerangka tata letak dasar satu halaman penuh yang memisahkan area bilah atas (appBar) dan konten utama (body), serta menyediakan dukungan konteks untuk menampilkan SnackBar.
   * AppBar berfungsi untuk menampilkan bilah navigasi di bagian paling atas halaman yang memuat judul aplikasi (MyPortfolio) dengan warna latar sesuai tema utama (colorScheme.primary).
   * Padding berfungsi untuk memberikan ruang jarak (margin bagian dalam) di sekeliling child widget-nya agar konten tidak menempel langsung ke tepi layar atau elemen lain.
   * Column berfungsi untuk menyusun daftar child widget secara vertikal dari atas ke bawah (digunakan pada kerangka utama body, InfoCard, dan isi ItemCard).
   * Row berfungsi untuk menyusun daftar child widget secara horizontal dari kiri ke kanan (digunakan untuk mensejajarkan tiga InfoCard secara merata dengan MainAxisAlignment.spaceEvenly).
   * Center berfungsi untuk memposisikan child widget di dalamnya tepat di bagian tengah ruang yang tersedia secara horizontal maupun vertikal.
   * SizedBox berfungsi untuk membuat kotak kosong dengan ukuran tetap (tinggi 16.0 dan 8.0) yang difungsikan sebagai pemisah jarak (spacer) antar-widget.
   * GridView.count (GridView) berfungsi untuk menampilkan kumpulan widget (ItemCard) dalam tata letak kisi (grid) berjumlah 3 kolom (crossAxisCount: 3) dengan ukuran tinggi yang menyesuaikan isi kontennya (shrinkWrap: true).
   * Container berfungsi sebagai kotak pembungkus serbaguna yang digunakan untuk mengatur ukuran lebar proporsional (MediaQuery.of(context).size.width / 3.5) dan padding bagian dalam pada InfoCard maupun ItemCard.
   * Card berfungsi untuk menampilkan kontainer bergaya Material Design dengan sudut membulat dan efek bayangan (elevation: 2.0) pada setiap InfoCard.
   * Material berfungsi untuk menyediakan permukaan kanvas Material untuk ItemCard agar mendukung pewarnaan latar (item.color), sudut melengkung (borderRadius), serta efek visual sentuhan dari InkWell.
   * Text berfungsi untuk menampilkan seluruh string teks ke layar dengan pengaturan gaya huruf (TextStyle) dan perataan (TextAlign).
   * Icon berfungsi untuk menampilkan ikon grafis vektor bawaan Material Icons (Icons.folder, Icons.add_circle, Icons.logout) dengan ukuran dan warna putih di dalam tombol menu.
   * InkWell berfungsi untuk menjadikan area ItemCard responsif terhadap sentuhan pengguna (onTap) sekaligus memberikan animasi efek riak air (ripple effect) khas Material Design saat ditekan.
   * SnackBar berfungsi untuk menampilkan bilah notifikasi singkat di bagian bawah layar (melalui ScaffoldMessenger) sebagai umpan balik interaktif setiap kali pengguna menekan salah satu tombol menu.

3. MaterialApp adalah widget pembungkus tingkat aplikasi di Flutter yang berfungsi sebagai pusat konfigurasi untuk membangun antarmuka berbasis sistem desain Material Design. Fungsi utama dari MaterialApp ialah menyediakan tema dan gaya visual global untuk aplikasi kita, serta mengatur halaman pertama yang dibuka dalam aplikasi. MaterialApp umum dijadikan root widget karena menyediakan konfigurasi dan dukungan untuk aplikasi Material Design, seperti tema, navigasi, dan lokalisasi. Widget turunannya dapat mengakses tema melalui Theme.of(context).

4. StatelessWidget tidak menyimpan state internal yang dapat berubah, sedangkan StatefulWidget memiliki objek State terpisah untuk mengelola state yang dapat berubah selama widget digunakan. Kita sebaiknya memilih StatelessWidget ketika widget yang ingin kita tampilkan tidak perlu menyimpan state, sedangkan kita sebaiknya memilih StatefulWidget ketika widget yang ingin kita tampilkan perlu menyimpan state. StatelessWidget dapat dibangun ulang ketika konfigurasi dari parent atau inherited widget yang diaksesnya berubah. Pada StatefulWidget, state yang dapat berubah disimpan dalam objek State terpisah, kemudian pemanggilan setState() menjadwalkan rebuild. Keduanya tetap memiliki konfigurasi widget yang immutable.

5. BuildContext adalah abstraksi lokasi/posisi suatu widget dalam widget tree yang umumnya digunakan sebagai parameter ketika ingin build suatu widget. Fungsinya ialah Flutter bisa mengetahui posisinya di widget tree dan semua ancestornya yang berguna untuk prinsip InheritedWidget dalam Flutter. Dalam build(BuildContext context), context digunakan untuk mengakses informasi dari ancestor yang sesuai, misalnya Theme.of(context) untuk tema, MediaQuery.of(context) untuk informasi tampilan, dan ScaffoldMessenger.of(context) untuk menampilkan SnackBar.

6. Hot reload di Flutter adalah konsep memperbarui widget setelah adanya perubahan kode melalui mekanisme penyuntikan file kode sumber Dart ke dalam Dart Virtual Machine (VM) yang sedang berjalan, lalu framework Flutter memperbarui widget tree (rebuild) dengan tidak menjalankan ulang main() atau initState() sehingga perubahan langsung terlihat dalam milidetik tanpa menghilangkan state aplikasi, sedangkan hot restart di Flutter adalah konsep memperbarui widget setelah adanya perubahan kode melalui mekanisme penyuntikan file kode sumber Dart ke dalam Dart Virtual Machine (VM) yang sedang berjalan, lalu dilakukan restart aplikasi Flutter (menjalankan ulang fungsi main()) sehingga menghilangkan state aplikasi. Salah satu contoh kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart ialah ketika kita mengubah nilai awal variabel di statefulwidget karena hot reload mempertahankan state lama sehingga ketika kita mengubah nilai, nilai terbaru tidak berubah di flutter app.

---

## 🤖 Pernyataan Penggunaan AI (AI Disclosure)

Dalam penyusunan dan peninjauan dokumentasi Tugas 7 ini, saya memanfaatkan asisten kecerdasan buatan dengan rincian sebagai berikut. Catatan ini mencakup bantuan yang tercatat dalam percakapan penyusunan README.

* **Alat yang Digunakan:** Codex
* **Strategi Prompting:**
  * Memberikan README proyek Django sebagai referensi format, lalu meminta dokumentasi untuk proyek Flutter dengan identitas pemilik, panduan setup, dan log pengembangan.
  * Memberikan PDF Tutorial 08 dan Tugas 7 agar dokumentasi disesuaikan dengan konteks tugas.
  * Meminta pembaruan log sesuai implementasi aktual dan peninjauan jawaban reflektif, dengan saran jawaban disampaikan di percakapan tanpa mengubah jawaban di README.
* **Bagian Spesifik yang Dibantu:**
  * Menyusun dan menyesuaikan deskripsi proyek, identitas pemilik, serta panduan menjalankan aplikasi Flutter di Chrome atau Android.
  * Memperbarui log Minggu 11 berdasarkan kode `lib/main.dart` dan `lib/menu.dart`.
  * Meninjau ketepatan konsep Flutter pada jawaban reflektif dan memberikan saran perbaikan di percakapan.
* **Log Obrolan / Riwayat:** [Tautan log chat atau ringkasan obrolan](https://chatgpt.com/s/cx_6afad543c9d081919a669e6dd0f69ad1)

### Analisis Kritis Keterbatasan AI & Perbaikan Manual
Dokumentasi yang dibantu AI perlu diperiksa terhadap spesifikasi tugas dan kode aktual. Panduan awal README berfokus pada Android, lalu disesuaikan setelah membaca Tutorial 08 yang mengutamakan Chrome untuk sesi lab. Log Django/HTML/CSS dan disclosure Tugas 1 yang terbawa dari referensi juga diganti agar sesuai dengan proyek Flutter minggu ini. Keberadaan nama tombol tidak membuktikan bahwa fiturnya sudah lengkap: berdasarkan kode saat ini, tombol hanya menampilkan SnackBar. Jawaban reflektif tetap dipertahankan untuk ditinjau dan diperbaiki sendiri berdasarkan saran di percakapan. Pembacaan kode untuk dokumentasi ini belum membuktikan aplikasi bebas masalah saat dijalankan atau bahwa hasil `flutter analyze` sudah bersih.
