"""API Routers"""
from fastapi import APIRouter
from app.routers.detection import router as detection_router

api_router = APIRouter()

# Include all routers
api_router.include_router(detection_router, prefix="/detection", tags=["detection"])

