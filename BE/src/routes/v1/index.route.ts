import { Router } from "express";
import exampleRoute from "./example.route";

const route = Router();
route.use("/examples", exampleRoute);
export default route;
