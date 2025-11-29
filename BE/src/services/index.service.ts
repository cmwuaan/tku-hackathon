import { ExampleService } from "./example.service";
import { AudioDetectionService } from "./audio-detection.service";

class V1Service {
  Example = new ExampleService();
  AudioDetection = new AudioDetectionService();
}
export const v1Service = new V1Service();
