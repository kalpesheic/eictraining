# AI Kubernetes Agent

On-demand Kubernetes troubleshooting powered by AI.

## Architecture

```text
Frontend (Next.js)
    ↓
FastAPI Backend (Orchestrator)
    ↓
Kubernetes Investigation Layer
    ↓
AI Kubernetes Agent
    ↓
LLM Reasoning (OpenRouter via InsForge)
    ↓
Root Cause + Suggested Fix
    ↓
Frontend Diagnosis
```

## Project Structure

```text
ai-kubernetes-agent/
├── backend/          # FastAPI orchestrator
├── frontend/         # Next.js UI
├── docs/             # Documentation
├── prompts/          # AI prompt templates
├── docker-compose.yml
└── README.md
```

## Quick Start

### Prerequisites

- Docker and Docker Compose

### Run with Docker

1. Copy environment files (already provided with defaults):

   ```bash
   cp backend/.env.example backend/.env
   cp frontend/.env.example frontend/.env
   ```

2. Start all services:

   ```bash
   docker compose up --build
   ```

3. Access the application:

   - Frontend: http://localhost:3000
   - Backend health: http://localhost:8000/health

### Local Development (without Docker)

**Backend:**

```bash
cd backend
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

**Frontend:**

```bash
cd frontend
npm install
npm run dev
```

## API Endpoints

| Method | Path     | Description              |
|--------|----------|--------------------------|
| GET    | /health  | Service health check     |

## Environment Variables

### Backend

| Variable             | Description                    |
|----------------------|--------------------------------|
| OPENROUTER_API_KEY   | OpenRouter API key (future)    |
| OPENROUTER_MODEL     | LLM model name (future)        |
| KUBECONFIG_PATH      | Path to kubeconfig (future)    |

### Frontend

| Variable                  | Description           |
|---------------------------|-----------------------|
| NEXT_PUBLIC_API_BASE_URL  | Backend API base URL  |

## Status

This is the foundation setup. Kubernetes investigation and AI reasoning are not yet implemented.
