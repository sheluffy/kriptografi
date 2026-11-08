# NFV-256 Cipher

Aplikasi web dan mobile berbasis **Flutter** untuk melakukan proses enkripsi dan dekripsi menggunakan algoritma **Neighbor-Feedback Vigenère 256 (NFV-256)**.

## Fitur Utama

* **Enkripsi & Dekripsi Dual-Mode:** Mendukung konversi Plaintext ke Ciphertext (berbasis desimal ASCII 0–255) dan sebaliknya.
* **Penanganan Spasi (`/`):** Karakter spasi ditangani secara khusus menggunakan token `/` agar struktur pesan tetap terjaga.
* **Tabel Rincian Langkah Iterasi:** Menyediakan rincian lengkap per karakter (indeks $i$, karakter asli, nilai $P$, kunci $K$, nilai *Feedback*, hingga hasil $C$) layaknya lembar kerja manual kriptografi.
* **Formula Card:** Penjelasan rumus matematis yang transparan dan mudah diakses langsung di dalam aplikasi.
* **Desain Responsif & Estetik:** Dibangun menggunakan prinsip Material 3 dengan tata letak kartu kontainer yang rapi dan profesional.

## Rumus Matematis NFV-256

* **Enkripsi ($C_i$):**
  $$C_i = (P_i + K_i + (C_{i-1} \bmod 10)) \bmod 256$$

* **Dekripsi ($P_i$):**
  $$P_i = (C_i - K_i - (C_{i-1} \bmod 10)) \bmod 256$$

* **Feedback:**
  $$\text{feedback} = C_{i-1} \bmod 10 \quad (\text{untuk iterasi pertama, } C_0 = 0)$$

## Struktur Folder Proyek

```text
lib/
├── models/
│   ├── nfv_step.dart         # Model data langkah iterasi per karakter
│   └── nfv_result.dart       # Model penampung hasil akhir & daftar langkah
├── services/
│   └── nfv256_service.dart   # Logika inti algoritma matematika NFV-256
├── views/
│   ├── home_page.dart        # Halaman utama dengan Tab Enkripsi & Dekripsi
│   └── widgets/
│       ├── formula_card.dart # Kartu referensi persamaan rumus
│       ├── result_box.dart   # Kontainer teks hasil enkripsi/dekripsi
│       ├── step_table.dart   # Tabel interaktif rincian iterasi langkah
│       └── tab_body.dart     # Pembungkus layout responsif
└── main.dart                 # Titik masuk utama (Entry Point) & Konfigurasi Tema

test/
└── widget_test.dart          # Pengujian otomatis widget dan navigasi UI
```

## Cara Menjalankan Proyek

Pastikan Anda sudah menginstal [Flutter SDK](https://flutter.dev/) di komputer Anda.

1. **Clone repositori ini:**
   ```bash
   git clone https://github.com/USERNAME_KAMU/nfv256_cipher.git
   cd nfv256_cipher
   ```

2. **Ambil dependensi pustaka:**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi:**
   * Untuk mode Web (Chrome):
     ```bash
     flutter run -d chrome
     ```
   * Untuk mode Desktop / Emulator Android:
     ```bash
     flutter run
     ```

## Menjalankan Unit & Widget Test

Untuk menjalankan pengujian otomatis guna memastikan aplikasi berjalan dengan baik:
```bash
flutter test
```

## Lisensi

Proyek ini dikembangkan untuk kebutuhan tugas kuliah mata kuliah Kriptografi.
