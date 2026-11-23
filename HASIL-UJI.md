# Hasil uji paket
Enam tes otomatis lulus, meliputi URL, pengaman permintaan, rekomendasi, potongan tumpang tindih, waktu subtitle, dan dimensi/durasi MP4 beserta audio. Sintaks JavaScript diperiksa dengan Node.

Uji melalui API aplikasi menggunakan trailer Sintel dari media.w3.org: unduh video, transkripsi Whisper tiny CPU (21 kata), 2 kandidat momen, koreksi kata, simpan, ekspor SRT/VTT dan MP4 1080 × 1920 dengan subtitle, unduh MP4 (1.102.358 byte), lalu hapus proyek. Uji ini memakai dependensi Python terisolasi dan FFmpeg, bukan Docker. File contoh dan model tidak disertakan.

Belum diverifikasi: image Docker di server tujuan, semua kontrol secara visual di browser, YouTube/Vimeo/Drive secara langsung, Ollama, benchmark video 30 menit atau statistik keberhasilan produksi. Uji browser otomatis terpisah disediakan; Chromium pada host pembuatan tidak berhasil menyelesaikan uji tersebut.
