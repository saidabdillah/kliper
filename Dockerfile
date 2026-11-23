FROM denoland/deno:bin-2.9.8 AS jsruntime
FROM python:3.12-slim-bookworm
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 CLIP_DATA=/data/projects HF_HOME=/data/models XDG_CACHE_HOME=/data/cache HOME=/home/studio OMP_NUM_THREADS=2 OPENBLAS_NUM_THREADS=1
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg fonts-dejavu-core libgomp1 ca-certificates && rm -rf /var/lib/apt/lists/* && useradd -m -u 10001 studio && install -d -o studio -g studio /data /data/projects /data/models /data/cache
COPY --from=jsruntime /deno /usr/local/bin/deno
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py pipeline.py ranking.py studio.py ./
COPY web web
COPY tests tests
USER studio
EXPOSE 8765
CMD ["uvicorn","app:app","--host","0.0.0.0","--port","8765","--workers","1","--no-proxy-headers"]
