# Kliper · ClipStudio Web

Ubah tautan video publik menjadi klip pendek. Edit potongan, rasio, posisi wajah dan subtitle di browser; ekspor MP4, SRT atau VTT. Aplikasi privat satu operator untuk server sendiri, bukan layanan publik multiakun.

**[Panduan pemasangan dan pemakaian](MULAI-DI-SINI.md)** · **[Pengujian](HASIL-UJI.md)** · **[Hasil CI](../../actions/workflows/verify.yml)**

```sh
git clone https://github.com/saidabdillah/kliper.git
cd kliper
docker compose up -d --build
```

Buka `http://localhost:8765` di server atau gunakan SSH tunnel dari laptop sebagaimana dijelaskan di panduan. Model transkripsi diunduh pada pemakaian pertama. Pemilihan momen default memakai skor transkrip; penilaian semantik dengan Ollama opsional. Tidak perlu kunci API.
