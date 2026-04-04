FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg curl build-essential git libsndfile1 && \
    rm -rf /var/lib/apt/lists/*

# Install PyTorch CPU first (GPU users can override with CUDA version)
RUN pip install --no-cache-dir \
    torch torchaudio --index-url https://download.pytorch.org/whl/cu118

# Install rvc-python and its deps
RUN pip install --no-cache-dir rvc-python

WORKDIR /app
VOLUME /app/rvc_models

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5050

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD curl -f http://localhost:5050/models || exit 1

CMD ["/entrypoint.sh"]
