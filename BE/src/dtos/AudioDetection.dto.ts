import { DetectionType } from "../enums/DetectionType";

export interface AudioDetectionResponseDto {
  detection_type: DetectionType;
  detection_result?: Record<string, unknown>;
  detection_message?: string;
  confidence?: number;
  time_processed?: Date;
}

