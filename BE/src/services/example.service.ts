import { PaginationRequest } from "../dtos/api.request";
import { Pagination } from "../dtos/api.response";
import {
  CreateExampleRequestDto,
  ExampleAddRangeItemDto,
  ExampleDto,
} from "../dtos/Example.dto";
import { NotFoundException } from "../exceptions/NotFoundException";
import { DEFAULT_INDEX, DEFAULT_LIMIT } from "../constants/Pagination";
import { IExample } from "../models/Example";

// In-memory storage
let examples: IExample[] = [];
let nextId = 1;

export class ExampleService {
  constructor() {}

  public async createExample(
    request: CreateExampleRequestDto
  ): Promise<ExampleDto> {
    try {
      const example: IExample = {
        id: String(nextId++),
        name: request.name,
        description: request.description,
        status: request.status,
        createdAt: new Date(),
        updatedAt: new Date(),
      };

      examples.push(example);

      return {
        id: example.id,
        name: example.name,
        description: example.description,
        status: example.status,
      };
    } catch (error) {
      throw new Error(`Error creating example: ${error}`);
    }
  }

  public async addRangeExamples(
    examplesData: ExampleAddRangeItemDto[]
  ): Promise<ExampleDto[]> {
    try {
      const newExamples: IExample[] = examplesData.map((data) => ({
        id: String(nextId++),
        name: data.name,
        description: data.description,
        status: data.status,
        createdAt: new Date(),
        updatedAt: new Date(),
      }));

      examples.push(...newExamples);

      return newExamples.map((example) => ({
        id: example.id,
        name: example.name,
        description: example.description,
        status: example.status,
      }));
    } catch (error) {
      throw new Error(`Error creating examples: ${error}`);
    }
  }

  public async getAllExamples(
    pagination: PaginationRequest
  ): Promise<Pagination<ExampleDto>> {
    const limit = pagination.limit ?? DEFAULT_LIMIT;
    const index = pagination.index ?? DEFAULT_INDEX;

    const startIndex = limit * index;
    const endIndex = startIndex + limit;
    const paginatedExamples = examples.slice(startIndex, endIndex);
    const total = examples.length;

    const response: Pagination<ExampleDto> = {
      items: paginatedExamples.map((example) => ({
        id: example.id,
        name: example.name,
        description: example.description,
        status: example.status,
      })),
      index: index,
      total: total,
    };

    return response;
  }

  public async getExampleById(id: string): Promise<ExampleDto> {
    const example = examples.find((e) => e.id === id);
    if (!example) {
      throw new NotFoundException(`Example with id '${id}' not found`);
    }

    return {
      id: example.id,
      name: example.name,
      description: example.description,
      status: example.status,
    };
  }

  public async updateExampleById(
    id: string,
    request: Partial<CreateExampleRequestDto>
  ): Promise<ExampleDto> {
    try {
      const exampleIndex = examples.findIndex((e) => e.id === id);
      if (exampleIndex === -1) {
        throw new NotFoundException(`Example with id '${id}' not found`);
      }

      const existingExample = examples[exampleIndex];
      const updatedExample: IExample = {
        ...existingExample,
        ...request,
        updatedAt: new Date(),
      };

      examples[exampleIndex] = updatedExample;

      return {
        id: updatedExample.id,
        name: updatedExample.name,
        description: updatedExample.description,
        status: updatedExample.status,
      };
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      throw new Error(`Error updating example: ${error}`);
    }
  }

  public async deleteExampleById(id: string): Promise<boolean> {
    const exampleIndex = examples.findIndex((e) => e.id === id);
    if (exampleIndex === -1) {
      throw new NotFoundException(`Example with id '${id}' not found`);
    }

    examples.splice(exampleIndex, 1);
    return true;
  }
}
