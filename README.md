# 🚀 Hermes Agent - Deployment Template

**Deployment mudah untuk Hermes Agent** (dari Nous Research) — Self-improving AI Agent dengan **persistent memory**, skill creation, dan **multi Groq API Key** support.

![Hermes Agent](https://hermes-agent.nousresearch.com/og-image.png)

## ✨ Features
- Self-improving agent (bisa bikin & improve skill sendiri)
- Persistent memory + user modeling
- **Multiple Groq API Keys** (otomatis rotation)
- Web UI + API Gateway
- Mudah deploy ke **Railway**, Docker, VPS

## 🚀 Quick Deploy ke Railway (Recommended)

1. **Fork** repo ini
2. Buka [Railway.app](https://railway.app) → **New Project** → Deploy from GitHub
3. Pilih repo ini
4. Tambahkan Environment Variables di Railway:

| Variable            | Required | Deskripsi                     |
|---------------------|----------|-------------------------------|
| `GROQ_API_KEY`      | Yes      | Groq API Key utama            |
| `GROQ_API_KEY_2`    | No       | Groq API Key kedua            |
| `GROQ_API_KEY_3`    | No       | Groq API Key ketiga           |

5. Klik Deploy.

---

## 🐳 Docker Compose (Local Testing)

```bash
git clone https://github.com/venezuela-alt/AGENT.git
cd AGENT

cp .env.example .env
# Edit .env dengan Groq API Key(s) lu

docker compose up -d
