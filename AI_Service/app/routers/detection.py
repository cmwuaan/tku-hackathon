"""
Detection Router
Handles audio detection endpoints
"""
from fastapi import APIRouter, HTTPException, UploadFile, File
from app.schemas.detection import DetectionRequest, DetectionResponse
from app.services.detection_service import DetectionService

router = APIRouter()
detection_service = DetectionService()


@router.post("/detect", response_model=DetectionResponse)
async def detect_audio(
    file: UploadFile = File(..., description="Audio file to detect")
):
    """
    Simple audio detection endpoint
    
    Args:
        file: Audio file to process
        
    Returns:
        DetectionResponse: Detection results
    """
    try:
        # Read file content
        contents = await file.read()
        
        # Process detection
        result = await detection_service.detect(contents, file.filename)
        
        return DetectionResponse(
            success=True,
            message="Detection completed successfully",
            data=result
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Detection failed: {str(e)}"
        )


@router.get("/status")
async def get_detection_status():
    """Get detection service status"""
    return {
        "status": "operational",
        "service": "audio_detection"
    }

