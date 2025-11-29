import express from "express";
import cors from "cors";
import v1Routes from "./routes/v1/index.route";
import { config } from "./config/dotenv";
import { globalExceptionMiddleware } from "./middleware/GlobalExceptionMiddleware";

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

app.use("/api/v1", v1Routes);
app.use(globalExceptionMiddleware);

app.listen(config.port, () => {
  console.log(`🚀 Server is running on http://localhost:${config.port}`);
});
