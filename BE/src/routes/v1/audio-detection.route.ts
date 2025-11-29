import { Router, Request, Response, NextFunction } from "express";
import { v1Controller } from "../../controllers/v1";
import multer from "multer";

const route = Router();

// Configure multer for audio file upload
const storage = multer.memoryStorage();
const upload = multer({
  storage: storage,
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB limit
  },
  fileFilter: (req, file, cb) => {
    // Accept only .wav files
    if (file.mimetype === "audio/wav" || file.originalname.toLowerCase().endsWith(".wav")) {
      cb(null, true);
    } else {
      cb(new Error("Only .wav audio files are allowed"));
    }
  },
});

route.post(
  "/",
  upload.single("audio"),
  async (req: Request, res: Response, next: NextFunction) => {
    await v1Controller.AudioDetection.detect(req, res, next);
  }
);

export default route;

