# Uji skenario API dengan Postman CLI

Postman hanya mengirim request dan memperlihatkan status/body GNews. Pesan `ApiException` tampil di aplikasi Flutter, yang menerjemahkan status dan jenis kegagalan tersebut.

1. Salin `env.example.json` menjadi `env.json` di folder ini, lalu ganti `GNEWS_API_KEY` dengan key GNews milik sendiri. File lokal itu tidak di-commit.
2. Jalankan salah satu request berikut dari folder `newsapp`.

## Empat skenario yang konsisten

```powershell
# 1. Key berbentuk 32 karakter tetapi tidak terdaftar -> HTTP 401
postman request GET "{{GNEWS_BASE_URL}}/top-headlines?country=id&lang=id&max=10&apikey=00000000000000000000000000000000" -e postman/env.json

# 2. Format key salah -> HTTP 400
postman request GET "{{GNEWS_BASE_URL}}/top-headlines?country=id&lang=id&max=10&apikey=salah123" -e postman/env.json

# 3. Query pencarian kosong -> HTTP 400 dengan pesan parameter q
postman request GET "{{GNEWS_BASE_URL}}/search?country=id&lang=id&max=10&apikey={{GNEWS_API_KEY}}&q=" -e postman/env.json

# 4. Endpoint salah -> HTTP 404
postman request GET "{{GNEWS_BASE_URL}}/top-headline?country=id&lang=id&max=10&apikey={{GNEWS_API_KEY}}" -e postman/env.json
```

Pemetaan di aplikasi: 401 `API key salah atau tidak terdaftar`; 400 `Permintaan tidak valid` (pesan server ikut ditampilkan); 404 `Alamat endpoint tidak ditemukan`. Empat pesan berbeda lain datang dari `ApiException`: timeout, koneksi terputus, sertifikat tidak valid, 429, 403, dan 5xx.

Untuk membuktikan timeout di Postman CLI, beri batas waktu pendek pada request valid:

```powershell
postman request GET "{{GNEWS_BASE_URL}}/top-headlines?country=id&lang=id&category=general&max=10&apikey={{GNEWS_API_KEY}}" -e postman/env.json --timeout 1
```

Timeout CLI hanya menguji koneksi Postman. Untuk melihat pesan timeout Flutter, atur `receiveTimeout` sementara ke 1 milidetik di `NewsApiService`, jalankan aplikasi, ambil screenshot, lalu kembalikan ke 15 detik.

**Jangan gunakan API key di screenshot, command history, atau repo publik.** Jika Postman menampilkan URI lengkap, samarkan parameter `apikey` sebelum melampirkan hasil.
