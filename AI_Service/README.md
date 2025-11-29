# AI Service - Taekwondo Tournament

FastAPI service for AI-powered audio detection.

## Prerequisites

- Python 3.11 or higher
- pip (Python package manager)
- Docker and Docker Compose (optional, for containerized deployment)

## Setup Options

### Option 1: Virtual Environment (Similar to node_modules)

The virtual environment (`venv/`) is Python's equivalent to `node_modules` - it isolates project dependencies.

#### Windows (PowerShell)

1. Run the setup script:
```powershell
.\setup_venv.ps1
```

2. Activate the virtual environment:
```powershell
.\venv\Scripts\Activate.ps1
```

3. Run the application:
```powershell
python main.py
```

#### Unix/Linux/Mac

1. Make the script executable and run it:
```bash
chmod +x setup_venv.sh
./setup_venv.sh
```

2. Activate the virtual environment:
```bash
source venv/bin/activate
```

3. Run the application:
```bash
python main.py
```

#### Manual Setup (All Platforms)

1. Create virtual environment:
```bash
# Windows
python -m venv venv

# Unix/Linux/Mac
python3 -m venv venv
```

2. Activate virtual environment:
```bash
# Windows PowerShell
.\venv\Scripts\Activate.ps1

# Windows CMD
venv\Scripts\activate.bat

# Unix/Linux/Mac
source venv/bin/activate
```

3. Install dependencies:
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

4. Run the application:
```bash
python main.py
```

Or with uvicorn (with auto-reload for development):
```bash
uvicorn main:app --reload
```

**Note:** Always activate the virtual environment before running the application. The `venv/` folder contains all your project dependencies (similar to `node_modules/`).

### Option 2: Docker (Recommended for Production)

#### Using Docker Compose (Easiest)

1. Build and run the container:
```bash
docker-compose up --build
```

2. Run in detached mode (background):
```bash
docker-compose up -d
```

3. View logs:
```bash
docker-compose logs -f
```

4. Stop the container:
```bash
docker-compose down
```

#### Using Docker directly

1. Build the image:
```bash
docker build -t ai-service-api .
```

2. Run the container:
```bash
docker run -d -p 8000:8000 --name ai-service-api ai-service-api
```

3. View logs:
```bash
docker logs -f ai-service-api
```

4. Stop the container:
```bash
docker stop ai-service-api
docker rm ai-service-api
```

## API Endpoints

- `GET /` - Health check
- `GET /health` - Health check
- `POST /api/v1/detection/detect` - Detect audio from uploaded file
- `GET /api/v1/detection/status` - Get detection service status

## Project Structure

```
.
├── main.py                 # FastAPI application entry point
├── Dockerfile              # Docker container configuration
├── docker-compose.yml     # Docker Compose configuration
├── requirements.txt       # Python dependencies
├── setup_venv.sh          # Virtual env setup (Unix/Linux/Mac)
├── setup_venv.ps1         # Virtual env setup (Windows)
├── .gitignore             # Git ignore rules
├── .dockerignore          # Docker ignore rules
├── venv/                  # Virtual environment (created after setup, like node_modules)
└── app/
    ├── routers/           # API route handlers
    │   └── detection.py   # Detection endpoints
    ├── schemas/           # Pydantic models
    │   └── detection.py   # Detection request/response models
    └── services/          # Business logic layer
        └── detection_service.py  # Detection service
```

## Development

Follow the Controller pattern with clear separation of concerns:
- **Routers**: Handle HTTP requests/responses
- **Schemas**: Define data models and validation
- **Services**: Contain business logic and AI model integration

## Accessing the API

Once running, the API will be available at:
- **Local**: http://localhost:8000
- **API Docs (Swagger)**: http://localhost:8000/docs
- **Alternative Docs (ReDoc)**: http://localhost:8000/redoc

## Virtual Environment vs Docker

- **Virtual Environment (`venv/`)**: 
  - Similar to `node_modules/` in Node.js
  - Isolates Python packages for this project
  - Use for local development
  - Must activate before running: `source venv/bin/activate` (Unix) or `.\venv\Scripts\Activate.ps1` (Windows)

- **Docker**:
  - Containerized environment
  - Consistent across all machines
  - Use for production or when you want isolation
  - No need to activate anything, just run `docker-compose up`

## Troubleshooting

### Virtual Environment Issues

**Windows PowerShell Execution Policy Error:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Python not found:**
- Ensure Python 3.11+ is installed and in PATH
- Try `python3` instead of `python` on Unix systems

### Docker Issues

**Port already in use:**
- Change the port in `docker-compose.yml` (e.g., `"8001:8000"`)
- Or stop the process using port 8000

**Permission denied (Linux):**
```bash
sudo docker-compose up
```

