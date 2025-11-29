import { ExampleController } from "./example.controller";
import { AudioDetectionController } from "./audio-detection.controller";

class V1Controller {
  Example = new ExampleController();
  AudioDetection = new AudioDetectionController();
}

export const v1Controller = new V1Controller();
