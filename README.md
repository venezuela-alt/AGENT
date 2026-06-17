# 🚀 Hermes Agent - Deployment Template

**Deployment mudah untuk Hermes Agent** (dari Nous Research) — Self-improving AI Agent dengan **persistent memory**, skill creation, dan multi Groq API Key support.

![Hermes Agent](https://hermes-agent.nousresearch.com/og-image.png)

## ✨ Features
- Self-improving agent (bisa bikin & improve skill sendiri)
- Persistent memory + user modeling
- **Multiple Groq API Keys** (otomatis rotation / load balancing)
- Web UI + API Gateway
- Mudah deploy ke **Railway**, Docker, VPS

## 🚀 Quick Deploy ke Railway

1. **Fork** repo ini
2. Buka [Railway.app](https://railway.app) → **New Project** → Deploy from GitHub
3. Pilih repo ini
4. Tambahkan Environment Variables:

| Variable            | Required | Keterangan                          |
|---------------------|----------|-------------------------------------|
| `GROQ_API_KEY`      | Yes      | Groq API Key utama                  |
| `GROQ_API_KEY_2`    | No       | Groq API Key kedua (rotation)       |
| `GROQ_API_KEY_3`    | No       | Groq API Key ketiga                 |

5. Deploy!

## 🐳 Docker & docker-compose (Local)

```bash
# Clone dulu
git clone https://github.com/venezuela-alt/AGENT.git
cd AGENT

cp .env.example .env
# Isi GROQ_API_KEY di .env

docker compose up -d|---------------------|----------|-------------------------------------|
| `GROQ_API_KEY`      | Yes      | Groq API Key utama                  |
| `GROQ_API_KEY_2`    | No       | Groq API Key kedua (rotation)       |
| `GROQ_API_KEY_3`    | No       | Groq API Key ketiga                 |

5. Deploy! Railway akan otomatis build.

---

## 🐳 Docker Manual

```bash
docker build -t hermes-agent .
docker run -d \
  -p 8000:8000 \
  -e GROQ_API_KEY=sk-groq-xxx \
  -e GROQ_API_KEY_2=sk-groq-yyy \
  --name hermes hermes-agent
