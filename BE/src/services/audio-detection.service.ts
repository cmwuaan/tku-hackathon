import { config } from "../config/dotenv";
import { AudioDetectionResponseDto } from "../dtos/AudioDetection.dto";
import { DetectionType } from "../enums/DetectionType";


export class AudioDetectionService {
  constructor() {}

  /**
   * Processes audio file through AI detection API
   * 
   * Purpose: Sends .wav audio file to AI model service for detection analysis
   * Input: Audio file buffer and filename
   * Output: Detection result with type (warning/danger/info), confidence, and message
   * Retry/Fallback: No retry strategy implemented - throws error on failure
   * 
   * @param audioFile - The audio file buffer from multer
   * @param filename - Original filename of the uploaded file
   * @returns Promise<AudioDetectionResponseDto> - Detection result from AI service
   */
  public async detectAudio(
    audioFile: Buffer,
    filename: string
  ): Promise<AudioDetectionResponseDto> {
    try {
      // Create FormData for multipart/form-data upload
      // Using FormData from global scope (Node.js 18+)
      // Convert Buffer to Uint8Array for Blob compatibility
      const formData = new FormData();
      const uint8Array = new Uint8Array(audioFile);
      const blob = new Blob([uint8Array], { type: "audio/wav" });
      formData.append("file", blob, filename);

      // Call AI model API
      const response = await fetch(`${config.aiModelApiUrl}/api/v1/detection/detect`, {
        method: "POST",
        body: formData,
      });

      if (!response.ok) {
        throw new Error(
          `AI detection API error: ${response.status} ${response.statusText}`
        );
      }

      const result = await response.json();

      // Map the AI response to our DTO structure
      // Assuming the AI API returns a structure like:
      // { type: "warning" | "danger" | "info", confidence: number, message: string, ... }
      const detectionResponse: AudioDetectionResponseDto = {
        detection_type: this.mapDetectionType(result.type || result.detection_type || "info"),
        detection_result: result.data.details,
        detection_message: result.message || result.detection_message || "Detection completed",
        confidence: result.data.confidence || result.confidence_score || 0,
        time_processed: new Date(),
      };

      return detectionResponse;
    } catch (error: any) {
      throw new Error(
        `Failed to process audio detection: ${error.message || error}`
      );
    }
  }

  /**
   * Maps AI model response type to DetectionType enum
   */
  private mapDetectionType(type: string): DetectionType {
    const normalizedType = type.toLowerCase();
    
    if (normalizedType === "warning" || normalizedType === "warn") {
      return DetectionType.WARNING;
    }
    if (normalizedType === "danger" || normalizedType === "critical") {
      return DetectionType.DANGER;
    }
    
    return DetectionType.INFO;
  }
}

