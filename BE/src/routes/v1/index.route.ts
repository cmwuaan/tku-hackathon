import { Router } from "express";
import exampleRoute from "./example.route";
import audioDetectionRoute from "./audio-detection.route";

const route = Router();
route.use("/examples", exampleRoute);
route.use("/audio-detection", audioDetectionRoute);
export default route;
