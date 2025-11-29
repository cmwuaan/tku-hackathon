import { Router, Request, Response, NextFunction } from "express";
import { v1Controller } from "../../controllers/v1";
import multer from "multer";

const route = Router();
const storage = multer.memoryStorage();
const upload = multer({ storage });

route.get("/", v1Controller.Example.getAll);
route.post("/", v1Controller.Example.create);
route.post(
  "/upload",
  upload.single("file"),
  async (req: Request, res: Response, next: NextFunction) => {
    await v1Controller.Example.uploadByExcel(req, res, next);
  }
);
route.get("/:id", v1Controller.Example.getById);
route.put("/:id", v1Controller.Example.updateById);
route.delete("/:id", v1Controller.Example.deleteById);

export default route;

