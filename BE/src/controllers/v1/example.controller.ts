import { NextFunction, Request, Response } from "express";
import { ApiResponse, Pagination } from "../../dtos/api.response";
import {
  CreateExampleRequestDto,
  ExampleAddRangeRequestDto,
  ExampleDto,
} from "../../dtos/Example.dto";
import { PaginationRequest } from "../../dtos/api.request";
import { v1Service } from "../../services/index.service";
import { ExcelExtractionService } from "../../utils/ExcelExtractionService";

export class ExampleController {
  public async create(
    req: Request<{}, {}, CreateExampleRequestDto>,
    res: Response,
    next: NextFunction
  ) {
    try {
      const body = req.body;
      const example = await v1Service.Example.createExample(body);
      res.status(201).json(ApiResponse.success<ExampleDto>(example));
    } catch (err) {
      next(err);
    }
  }

  public async addRange(
    req: Request<{}, {}, ExampleAddRangeRequestDto>,
    res: Response,
    next: NextFunction
  ) {
    try {
      const body = req.body;
      const examples = await v1Service.Example.addRangeExamples(body.items);
      res.status(201).json(ApiResponse.success<ExampleDto[]>(examples));
    } catch (err) {
      next(err);
    }
  }

  public async getAll(
    req: Request<{}, {}, {}, PaginationRequest>,
    res: Response,
    next: NextFunction
  ) {
    try {
      const examples = await v1Service.Example.getAllExamples(req.query);
      res
        .status(200)
        .json(ApiResponse.success<Pagination<ExampleDto>>(examples));
    } catch (err) {
      next(err);
    }
  }

  public async getById(
    req: Request<{ id: string }>,
    res: Response,
    next: NextFunction
  ) {
    try {
      const example = await v1Service.Example.getExampleById(req.params.id);
      res.status(200).json(ApiResponse.success<ExampleDto>(example));
    } catch (err) {
      next(err);
    }
  }

  public async updateById(
    req: Request<{ id: string }, {}, Partial<CreateExampleRequestDto>>,
    res: Response,
    next: NextFunction
  ) {
    try {
      const example = await v1Service.Example.updateExampleById(
        req.params.id,
        req.body
      );
      res.status(200).json(ApiResponse.success<ExampleDto>(example));
    } catch (err) {
      next(err);
    }
  }

  public async deleteById(
    req: Request<{ id: string }>,
    res: Response,
    next: NextFunction
  ) {
    try {
      await v1Service.Example.deleteExampleById(req.params.id);
      res.status(204).end();
    } catch (err) {
      next(err);
    }
  }

  public async uploadByExcel(
    req: Request<{}, {}, { file: Express.Multer.File }>,
    res: Response,
    next: NextFunction
  ) {
    try {
      if (!req.file) {
        return res.status(400).json({ error: "No file uploaded" });
      }

      const excelService = new ExcelExtractionService<
        CreateExampleRequestDto
      >();
      const examples = excelService.extractDataFromExcel(req.file);
      const response = await v1Service.Example.addRangeExamples(examples);
      res.status(200).json(ApiResponse.success<ExampleDto[]>(response));
    } catch (error: any) {
      next(error);
    }
  }
}