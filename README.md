# News App - Project 7

Aplikasi Flutter untuk membaca berita Indonesia dari GNews. Materi utama PDF sudah diterapkan: Dio, model response, error handling, FutureBuilder (loading/error/kosong/data), pilihan kategori, refresh, halaman detail, navigasi halaman di dalam `IndexedStack`, format tanggal Indonesia, dan dukungan gambar web.

Untuk output aplikasi terdapat pada folder output/public. Berisi screen capture dari aplikasi yang sedang dijalankan hingga tes eror 400 hingga 404

## Menjalankan

1. Salin `config/env.example.json` menjadi `config/env.json`.
2. Isi `GNEWS_API_KEY` dengan API key GNews milikmu. Jangan commit file `env.json`.
3. Jalankan:

```sh
flutter pub get
flutter run --dart-define-from-file=config/env.json
```

Untuk Chrome, tambahkan `-d chrome` setelah `flutter run`. API key di build web terlihat di JavaScript browser; gunakan proxy production jika dipublikasikan.

## Uji error dengan Postman CLI

Salin `postman/env.example.json` menjadi `postman/env.json`, isi API key lokal, lalu ikuti [tutorial empat skenario error di Command Prompt](postman/README.md). File environment lokal tidak di-commit.

## Bagian latihan untuk dikerjakan

Kedua latihan bagian 9 PDF sudah diterapkan:

- Tombol pencarian di AppBar membuka dialog dan mengarahkan ke halaman hasil yang memakai `FutureBuilder` serta `searchNews()`.
- Future berita disimpan per kategori di `Map<String, Future<List<ArticleModel>>>`; kategori yang pernah dimuat menggunakan hasil Future yang sama. Retry dan pull-to-refresh memuat ulang kategori aktif.

## Proxy production

`proxy-gnews/` berisi contoh Cloudflare Worker dari PDF. Deploy Worker, simpan key menggunakan `npx wrangler secret put GNEWS_API_KEY`, lalu salin `config/env.prod.example.json` ke `config/env.prod.json` dan isi URL Worker. Build release sesuai materi:

```sh
flutter build apk --release --obfuscate --split-debug-info=build/debug-info --dart-define-from-file=config/env.prod.json
```

Jangan memasukkan file env lokal atau `build/debug-info` ke repo.
