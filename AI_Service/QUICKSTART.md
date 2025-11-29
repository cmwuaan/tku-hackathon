# Quick Start Guide

## 🚀 Fastest Way to Get Started

### Using Docker (Recommended)

```bash
# Build and run
docker-compose up --build

# Access API at http://localhost:8000
# API docs at http://localhost:8000/docs
```

### Using Virtual Environment

**Windows:**
```powershell
.\setup_venv.ps1
.\venv\Scripts\Activate.ps1
python main.py
```

**Unix/Linux/Mac:**
```bash
chmod +x setup_venv.sh
./setup_venv.sh
source venv/bin/activate
python main.py
```

## 📋 Common Commands

### Virtual Environment

| Action | Windows | Unix/Linux/Mac |
|--------|---------|----------------|
| Activate | `.\venv\Scripts\Activate.ps1` | `source venv/bin/activate` |
| Deactivate | `deactivate` | `deactivate` |
| Install deps | `pip install -r requirements.txt` | `pip install -r requirements.txt` |
| Run app | `python main.py` | `python main.py` |
| Run with reload | `uvicorn main:app --reload` | `uvicorn main:app --reload` |

### Docker

| Action | Command |
|--------|---------|
| Build & Run | `docker-compose up --build` |
| Run in background | `docker-compose up -d` |
| View logs | `docker-compose logs -f` |
| Stop | `docker-compose down` |
| Rebuild | `docker-compose up --build --force-recreate` |

## 🔍 Verify Installation

1. Start the application (using either method above)
2. Open browser: http://localhost:8000
3. Check health: http://localhost:8000/health
4. View API docs: http://localhost:8000/docs

## 📝 Notes

- **venv/** folder = Python's equivalent to `node_modules/`
- Always activate venv before running: `source venv/bin/activate` or `.\venv\Scripts\Activate.ps1`
- Docker doesn't require activation - everything is isolated in the container

