# 🚀 Hermes Agent - Deployment Template

**Deployment mudah untuk Hermes Agent** (dari Nous Research) — Self-improving AI Agent dengan **persistent memory**, skill creation, **multi Groq API Key**, dan **Fireworks AI fallback** support.

---

## ✨ Features

- Self-improving agent (bisa bikin & improve skill sendiri)
- Persistent memory + user modeling
- **Multiple Groq API Keys** — otomatis round-robin rotation
- **Fireworks AI fallback** — otomatis switch ke Fireworks kalau semua Groq key error
- Web UI + API Gateway
- Mudah deploy ke **Railway**, Docker, VPS

---

## 🚀 Quick Deploy ke Railway (Recommended)

1. **Fork** repo ini
2. Buka [Railway.app](https://railway.app) → **New Project** → Deploy from GitHub
3. Pilih repo ini
4. Tambahkan Environment Variables:

| Variable | Required | Deskripsi |
|---|---|---|
| `GROQ_API_KEY` | ✅ Yes | Groq API Key utama |
| `GROQ_API_KEY_2` | No | Groq API Key ke-2 (rotation) |
| `GROQ_API_KEY_3` | No | Groq API Key ke-3 (rotation) |
| `FIREWORKS_API_KEY` | No | [Fireworks AI](https://app.fireworks.ai) key (fallback) |
| `FIREWORKS_FALLBACK_MODEL` | No | Model Fireworks (default: `accounts/fireworks/models/llama-v3p1-70b-instruct`) |
| `TELEGRAM_BOT_TOKEN` | No | Token bot Telegram |

5. Klik **Deploy**

> **Fireworks AI** dipakai otomatis sebagai fallback kalau semua Groq key error (rate limit, credit habis, dll). Daftar dan ambil API key di [app.fireworks.ai](https://app.fireworks.ai/settings/users/api-keys).

---

## 🐳 Docker Compose (Local)

```bash
git clone https://github.com/venezuela-alt/AGENT.git
cd AGENT

cp .env.example .env
# Edit .env — isi GROQ_API_KEY (wajib) dan key lainnya sesuai kebutuhan

docker compose up -d --build
```

Agent jalan di `http://localhost:8000`.

---

## ⚙️ Cara Kerja Multi-Key & Fallback

### Multi Groq Keys (Round Robin)
Kalau kamu set lebih dari satu `GROQ_API_KEY`, Hermes otomatis rotasi ke key berikutnya tiap request (round_robin). Berguna banget buat nge-bypass rate limit.

### Fireworks AI Fallback
Kalau **semua** Groq key lagi error (rate limit, credit habis, dll), Hermes otomatis switch ke Fireworks AI. Setelah Groq normal lagi, balik ke Groq sendiri.

Model Fireworks yang bisa dipakai: lihat di [fireworks.ai/models](https://fireworks.ai/models). Beberapa yang populer:
- `accounts/fireworks/models/llama-v3p1-70b-instruct` (default)
- `accounts/fireworks/models/deepseek-v3`
- `accounts/fireworks/models/qwen2p5-72b-instruct`

---

## 🔧 Troubleshooting

**`WARNING: Auxiliary: marking openrouter unhealthy`**  
→ Kredit OpenRouter kamu habis. Kalau kamu gak pakai OpenRouter sebagai provider utama, warning ini aman diabaikan.

**`Auxiliary Nous client unavailable: no Nous authentication found`**  
→ Hermes nyoba konek ke Nous Portal tapi belum di-auth. Jalankan `hermes auth` kalau pakai Nous, atau abaikan kalau kamu pakai Groq/Fireworks.

**`Gemini returned HTTP 404: model anthropic/claude-opus-4.6`**  
→ Format model salah! Model Anthropic tidak bisa dipanggil lewat endpoint Gemini. Pastikan `HERMES_MODEL` di config menggunakan model Groq, bukan `anthropic/xxx`.

**Port 8000 sudah dipakai**  
→ Ganti port di `docker-compose.yml`: ubah `"8000:8000"` jadi misalnya `"8080:8000"`.

## 🔥 Pakai Fireworks.ai (Rekomendasi saat ini)

Karena Groq/OpenAI susah, pakai **Fireworks.ai**:

1. Daftar di [app.fireworks.ai](https://app.fireworks.ai) → dapatkan API Key.
2. Tambahkan `FIREWORKS_API_KEY` di Railway Variables.
3. Redeploy.

Model yang bagus di Fireworks:
- `accounts/fireworks/models/llama-v3p3-70b-instruct`
- `accounts/fireworks/models/deepseek-r1`

---

## 📁 Struktur File

```
AGENT/
├── Dockerfile          # Build image (runtime config, bukan build-time)
├── entrypoint.sh       # Script startup: setup config + launch Hermes
├── docker-compose.yml  # Untuk local development
├── railway.toml        # Config deploy ke Railway
├── .env.example        # Template environment variables
└── README.md
```
