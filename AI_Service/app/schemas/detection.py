"""
Detection Schemas
Input/Output models for detection endpoints
"""
from pydantic import BaseModel
from typing import Optional, Dict, Any


class DetectionRequest(BaseModel):
    """Request schema for detection"""
    filename: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None


class DetectionData(BaseModel):
    """Detection result data"""
    detected: bool
    confidence: float
    details: Optional[Dict[str, Any]] = None


class DetectionResponse(BaseModel):
    """Response schema for detection"""
    success: bool
    message: str
    data: Optional[DetectionData] = None

