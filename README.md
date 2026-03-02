# CV / Portfolio Website

Repository ini berisi halaman **CV/portfolio statis** berbasis HTML + CSS + JavaScript, beserta dua skrip provisioning server (Apache/PHP dan MariaDB) untuk kebutuhan deployment lingkungan Moodle.

## Struktur proyek

- `index.html` → halaman utama portfolio.
- `website.sh` → skrip instalasi Apache + PHP 8.1 + unduh Moodle.
- `database.sh` → skrip instalasi MariaDB + pembuatan database/user Moodle.
- `CNAME` → konfigurasi domain custom untuk hosting statis (mis. GitHub Pages).

## Menjalankan website portfolio (lokal)

Karena ini situs statis, tidak perlu build tool khusus.

### Opsi 1: Buka langsung

Cukup buka file `index.html` di browser.

### Opsi 2: Jalankan server lokal sederhana

```bash
python3 -m http.server 8080
```

Lalu akses:

```text
http://localhost:8080
```

## Deployment skrip server (opsional)

> ⚠️ `website.sh` dan `database.sh` ditujukan untuk server Ubuntu/Debian dengan akses root/sudo.

### 1) Setup database

```bash
sudo bash database.sh
```

Yang dilakukan:

- Install MariaDB.
- Enable/start service MariaDB.
- Ubah `bind-address` ke `0.0.0.0` (remote access).
- Buat database `moodle` dan user `heralt`.

### 2) Setup web server + Moodle

```bash
sudo bash website.sh
```

Yang dilakukan:

- Install Apache2 + modul PHP 8.1.
- Download paket Moodle 4.5.
- Ekstrak Moodle ke `/var/www/html/moodle`.
- Buat direktori data `/var/www/moodledata`.
- Atur permission dan beberapa parameter `php.ini`.

## Catatan keamanan

- Ganti kredensial database default sebelum digunakan di produksi.
- Batasi akses port database via firewall/security group.
- Pertimbangkan penggunaan HTTPS dan hardening tambahan pada Apache/MariaDB.

## Lisensi

Belum ada lisensi khusus di repository ini. Tambahkan file `LICENSE` jika ingin mendefinisikan penggunaan ulang kode.
