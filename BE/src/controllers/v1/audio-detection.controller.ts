import { NextFunction, Request, Response } from "express";
import { ApiResponse } from "../../dtos/api.response";
import { AudioDetectionResponseDto } from "../../dtos/AudioDetection.dto";
import { v1Service } from "../../services/index.service";

export class AudioDetectionController {
  public async detect(
    req: Request,
    res: Response,
    next: NextFunction
  ) {
    try {
      if (!req.file) {
        return res.status(400).json(
          ApiResponse.error("No audio file uploaded")
        );
      }

      // Validate file type
      if (!req.file.originalname.toLowerCase().endsWith(".wav")) {
        return res.status(400).json(
          ApiResponse.error("Only .wav audio files are supported")
        );
      }

      // Process audio detection
      const detectionResult = await v1Service.AudioDetection.detectAudio(
        req.file.buffer,
        req.file.originalname
      );

      res.status(200).json(
        ApiResponse.success<AudioDetectionResponseDto>(detectionResult)
      );
    } catch (err) {
      next(err);
    }
  }
}

