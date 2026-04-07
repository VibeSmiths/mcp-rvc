# mcp-rvc

GPU service for voice cloning via Retrieval-based Voice Conversion (CUDA + ROCm).

Part of the [CRAFT](https://github.com/VibeSmiths/VideoIdeas) content studio.

## Overview

RVC converts any voice recording to sound like a target speaker using a trained voice model. In CRAFT, it's used as an optional post-processor for TTS — any TTS service (Edge, ElevenLabs, OpenAI) can have RVC applied to clone a custom voice.

## API

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/models` | GET | List available voice models |
| `/convert` | POST | Convert audio using a voice model |

## Usage

```bash
docker build -t rvc .
docker run --gpus all -p 5050:5050 -v ./models:/app/models rvc
```

Place `.pth` voice model files in the `models/` directory. The first model is auto-loaded on startup.

### AMD GPU (ROCm)

```bash
docker build -f Dockerfile.rocm -t rvc-rocm .
docker run --device /dev/kfd --device /dev/dri -p 5050:5050 -v ./models:/app/models rvc-rocm
```

Requires NVIDIA GPU with CUDA or AMD GPU with ROCm.
