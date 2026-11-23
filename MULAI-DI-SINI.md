# ClipStudio Web — pasang di server baru

Paket ini tidak membutuhkan SIRUSA, basis data SIRUSA, atau kunci API. Aplikasi untuk **satu operator tepercaya**, bukan layanan publik multiakun. Video, transkrip, dan hasil disimpan pada server yang Anda pilih. Tidak ada unggahan ke layanan transkripsi. Internet diperlukan untuk mengambil video publik, memasang dependensi dan mengunduh model pertama kali.

## 1. Jalankan di VPS/server tujuan
Gunakan server Linux dengan Docker Engine dan plugin Docker Compose. Saran awal untuk uji: 4 vCPU, RAM 8 GB, disk kosong 20 GB; kebutuhan nyata bergantung pada jumlah dan panjang video. **Bukan perintah untuk server SIRUSA.** Salin ZIP ke server tujuan. Buka terminal di folder tempat ZIP disimpan:

```bash
unzip ClipStudio-Web.zip
cd ClipStudio
docker compose up -d --build
docker compose logs -f web
```
Tunggu sampai log menunjukkan Uvicorn berjalan pada port 8765. Tekan Ctrl+C untuk keluar dari tampilan log; aplikasi tetap hidup.

## 2. Buka web dari laptop
Di terminal **laptop** (PowerShell, Terminal macOS, atau Linux), ganti `user` dan `IP_SERVER_BARU` dengan akun SSH dan alamat server baru:

```bash
ssh -N -L 8765:127.0.0.1:8765 user@IP_SERVER_BARU
```
Biarkan terminal terbuka. Di browser laptop, buka `http://localhost:8765`. Jika browser langsung di server, tidak perlu tunnel. Port web sengaja tidak terbuka ke internet. Jangan membuka port atau menaruh layanan ini di domain publik tanpa autentikasi, izin per proyek, TLS, pembatasan trafik, dan kebijakan jaringan keluar.

## 3. Buat klip pertama
1. Tempel tautan video milik Anda atau yang berizin. Pilih **Periksa video**. Server mengunduh sumber dan menyiapkan pratinjau. Batas masukan 1 GiB, 2 jam; butuh trek audio.
2. Pilih bahasa, durasi sasaran dan rasio. Klik **Buat klip**. Transkripsi Whisper berjalan di CPU. Model disimpan di volume lokal setelah unduhan pertama.
3. Buka **Edit klip**, geser titik potong, buang jeda, koreksi kata, pilih gaya subtitle. Matikan **Ikuti wajah** untuk menggeser posisi manual. Zona aman hanya garis bantu; tidak tercetak di MP4.
4. **Simpan** menyimpan edit tanpa mengubah sumber. **Ekspor MP4** merender video H.264 1080p dengan audio AAC. Tombol **SRT/VTT** menghasilkan berkas terpisah dengan waktu setelah pemotongan. Klik tautan unduhan jika browser tidak mengunduh otomatis.
5. Dari **Semua proyek**, klik **Hapus** hanya bila salinan yang diperlukan sudah diunduh. Ini menghapus video, transkrip, edit dan ekspor proyek tersebut. Tidak ada penghapusan otomatis.

## Model penilai momen (opsional)
Default: transkripsi AI dengan Faster-Whisper; segmen dinilai menurut isi dan pola transkrip. Judul default berupa petikan transkrip. Untuk judul dan peringkat semantik dari LLM pada server sendiri, aktifkan Ollama (butuh unduhan dan RAM tambahan):

```bash
docker compose --profile semantic up -d ollama
docker compose exec ollama ollama pull qwen2.5:3b
```
Buat file `.env` di samping `compose.yaml`, berisi `OLLAMA_MODEL=qwen2.5:3b`. Jalankan `docker compose --profile semantic up -d`. Hasil baru menampilkan metode penilaian aktual. Bila model gagal, aplikasi memakai skor transkrip. Model menilai kandidat; skor bukan perkiraan peluang viral yang terkalibrasi.

## Operasi dan batas versi ini
- Satu tugas berat sekaligus. Muat ulang halaman dan buka proyek untuk mengikuti proses. Setelah server terhenti, proses aktif ditandai gagal; hasil lama yang sudah tersimpan tetap ada.
- Sumber publik yang didukung: tautan video tunggal YouTube, Vimeo numerik, Google Drive `/file/d/.../view`, serta HTTPS MP4/MOV. Playlist, login, video privat, DRM dan bypass pemblokiran tidak didukung. Sebagian penyedia menolak IP pusat data. Gunakan tautan langsung berizin bila tersedia. Pembaruan ekstraktor: jalankan `docker compose build --no-cache web` lalu `docker compose up -d web`.
- Jumlah hasil mengikuti isi video, maksimal 15. Audio pendek bisa menghasilkan kurang dari 3. Target 3 menit untuk video 30 menit dan tingkat keberhasilan 98,5% belum dibuktikan. Klip hasil edit maksimal 10 menit, 12 potongan tengah.
- Auto-framing mengikuti estimasi posisi wajah terbesar, bukan identifikasi pembicara berdasarkan suara. Periksa percakapan dengan beberapa wajah. Pratinjau browser mendekati hasil FFmpeg; untuk tipografi, posisi dan animasi final, periksa MP4. Ekspor menggunakan font DejaVu; gaya mengikuti enam preset, tidak menjanjikan font komersial atau tampilan identik per piksel.
- `docker compose stop` menghentikan tanpa menghapus proyek. `docker compose start` menyalakan lagi. Cadangkan volume `studio-data` sebelum pemeliharaan. Jangan gunakan `down -v` jika data masih dibutuhkan.
- Pengujian di server baru: `docker compose exec web python -m unittest discover -s tests`. Uji sungguhan dengan unduhan contoh dan model: `docker compose exec web python tests/live_check.py`. Uji ini memerlukan jaringan, ruang kosong, dan CPU; jangan jalankan bersamaan dengan ekspor.
