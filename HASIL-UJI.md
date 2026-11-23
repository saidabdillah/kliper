# Pengujian ClipStudio

## Hasil yang sudah diamati
- 13 tes otomatis lulus. Meliputi validasi URL dan konfigurasi, penguncian tugas, hapus proyek, baca media parsial, simpan/buka edit, pemetaan waktu setelah potongan, serta ekspor. Uji render mengodekan **keenam** gaya subtitle dengan cakupan tiga rasio dan 30/60 fps. Dimensi, frame rate, serta piksel subtitle diperiksa, bukan hanya keberadaan file.
- Uji browser Chromium nyata memakai proyek sintetis dengan media hasil FFmpeg: URL tidak valid, daftar proyek, enam pilihan gaya, tiga rasio, zona aman, pan/zoom, geser nilai trim, buang bagian tengah, koreksi kata, simpan/buka ulang, unduh MP4/SRT/VTT, hapus proyek. Editor diperiksa pada lebar 375 dan 1280 piksel, tanpa overflow halaman atau error JavaScript tak tertangani dalam alur tersebut.
- Uji API terpisah dengan video sungguhan (trailer Sintel publik W3C): model Whisper `tiny` menghasilkan 21 kata dan 2 kandidat. Koreksi teks, potong, render H.264 1080 × 1920, ekspor SRT/VTT, lalu hapus proyek berhasil. Angka tersebut merupakan hasil satu contoh, bukan target untuk semua input.

## Jalankan ulang
```sh
docker compose build web
docker compose run --rm web python -m unittest discover -s tests -v
docker compose run --rm -e WHISPER_MODEL=tiny web python tests/live_check.py
```
Uji browser di lingkungan Python terpisah (perlu FFmpeg/FFprobe pada PATH):
```sh
python -m pip install -r requirements.txt playwright
python -m playwright install chromium
python tests/browser_editor.py
```

Lihat **Actions → Verify ClipStudio** untuk hasil build Docker, status layanan, integrasi jaringan dan uji browser pada SHA yang Anda pasang. Tidak ada deploy otomatis. Akses langsung penyedia YouTube/Vimeo/Drive tergantung kebijakan mereka. Uji contoh MP4 bukan bukti semua penyedia, perangkat, bahasa, Ollama, atau KPI pemrosesan 30 menit sudah tervalidasi.
