# AGENT

# 🚀 Hermes Agent Deployment Template

Deployment mudah **Hermes Agent** (Nous Research) — self-improving AI agent dengan persistent memory & skill creation.

![Hermes Agent](https://hermes-agent.nousresearch.com/og-image.png)

## Features
- Self-improving agent (bikin & improve skill sendiri)
- Persistent memory + user modeling
- Support **multiple Groq API keys** (rotation otomatis)
- Easy deploy ke **Railway**, Docker, VPS
- Gateway mode (web UI + API)

## Quick Deploy ke Railway

1. Fork repo ini
2. Buka [Railway.app](https://railway.app) → New Project → Deploy from GitHub
3. Pilih repo ini
4. Tambahkan Environment Variables:
   - `GROQ_API_KEY` → isi salah satu Groq key lu
   - `GROQ_API_KEY_2` → (opsional) key kedua
   - dst.

Railway akan otomatis build & jalankan.

## Manual Docker

```bash
docker build -t hermes-agent .
docker run -d \
  -p 8000:8000 \
  -e GROQ_API_KEY=sk-... \
  -e GROQ_API_KEY_2=sk-... \
  --name hermes hermes-agent
