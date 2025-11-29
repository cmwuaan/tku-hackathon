# Project Coding Rules and Patterns

This document outlines all coding patterns, architectural rules, and conventions used in this TypeScript/Express/Mongoose project.

## Table of Contents
1. [Project Architecture](#project-architecture)
2. [Directory Structure](#directory-structure)
3. [Naming Conventions](#naming-conventions)
4. [API Design Patterns](#api-design-patterns)
5. [Error Handling Patterns](#error-handling-patterns)
6. [Data Transfer Objects (DTOs)](#data-transfer-objects-dtos)
7. [Service Layer Patterns](#service-layer-patterns)
8. [Controller Layer Patterns](#controller-layer-patterns)
9. [Database/Model Patterns](#databasemodel-patterns)
10. [Mapping Patterns](#mapping-patterns)
11. [Validation Patterns](#validation-patterns)
12. [Routing Patterns](#routing-patterns)
13. [Middleware Patterns](#middleware-patterns)
14. [Configuration Patterns](#configuration-patterns)
15. [TypeScript Configuration](#typescript-configuration)
16. [File Upload Patterns](#file-upload-patterns)
17. [Pagination Patterns](#pagination-patterns)
18. [Exception Patterns](#exception-patterns)

---

## Project Architecture

### Layered Architecture
The project follows a **strict layered architecture** with clear separation of concerns:

```
Routes → Controllers → Services → Models (Database)
```

**Rules:**
- Controllers should **never** directly access models
- Services contain all business logic
- Controllers only handle HTTP request/response
- Models are only accessed through Services

### API Versioning
- All routes are versioned using `/api/v1` prefix
- Controllers, services, and routes are organized under `v1` folders
- Future versions (v2, v3) should follow the same structure

---

## Directory Structure

### Standard Directory Layout
```
src/
├── annonations/        # Custom decorators (e.g., validation)
├── config/            # Configuration files (env, database)
├── constants/         # Application constants
├── controllers/       # HTTP request handlers
│   └── v1/           # Versioned controllers
├── dtos/             # Data Transfer Objects
├── enums/            # TypeScript enums
├── exceptions/       # Custom exception classes
├── mapping/          # Object mapping profiles
│   └── profiles/     # Mapping profile implementations
├── middleware/       # Express middleware
├── models/           # Mongoose models/schemas
├── routes/           # Route definitions
│   └── v1/          # Versioned routes
├── services/         # Business logic layer
└── utils/            # Utility functions/classes
```

**Rules:**
- Each feature/resource should have corresponding files in controllers, services, routes, dtos, and models
- Keep related files together (e.g., `tournament.controller.ts`, `tournament.service.ts`, `Tournament.dto.ts`)

---

## Naming Conventions

### Files
- **Controllers**: `[resource].controller.ts` (e.g., `player.controller.ts`)
- **Services**: `[resource].service.ts` (e.g., `player.service.ts`)
- **Routes**: `[resource].route.ts` (e.g., `player.route.ts`)
- **DTOs**: `[Resource].dto.ts` (e.g., `Player.dto.ts`)
- **Models**: `[Resource].ts` (e.g., `Player.ts`)
- **Exceptions**: `[ExceptionName]Exception.ts` (e.g., `NotFoundException.ts`)
- **Enums**: `[EnumName].ts` (e.g., `Gender.ts`)
- **Utils**: `[UtilityName]Service.ts` or `[UtilityName].ts`

### Classes
- **PascalCase** for all classes
- Controllers: `[Resource]Controller` (e.g., `PlayerController`)
- Services: `[Resource]Service` (e.g., `PlayerService`)
- Exceptions: `[ExceptionName]Exception` (e.g., `NotFoundException`)
- DTOs: `[Resource]Dto`, `[Resource]RequestDto`, `[Resource]ResponseDto`

### Methods
- **camelCase** for all methods
- Controller methods: `create`, `getAll`, `getById`, `updateById`, `deleteById`
- Service methods: `create[Resource]`, `getAll[Resources]`, `get[Resource]ById`, `update[Resource]ById`, `delete[Resource]ById`

### Variables and Properties
- **camelCase** for variables and properties
- Use descriptive names (e.g., `tournamentGroup`, `playerId`)

### Constants
- **UPPER_SNAKE_CASE** for constants (e.g., `DEFAULT_LIMIT`, `DEFAULT_INDEX`)

### Routes/URLs
- **kebab-case** for route paths (e.g., `/tournament-groups`, `/rounds`)
- Use plural nouns for resource names

### Database Collections
- Use `TableName` enum to define collection names
- Collection names are **PascalCase** (e.g., `TournamentGroup`, `Player`)

---

## API Design Patterns

### HTTP Methods and Status Codes
- **GET**: Retrieve resources
  - `200 OK` for successful retrieval
  - `404 Not Found` for missing resources
- **POST**: Create resources
  - `201 Created` for successful creation
  - `400 Bad Request` for validation errors
- **PUT**: Update resources
  - `200 OK` for successful update
  - `404 Not Found` for missing resources
- **DELETE**: Remove resources
  - `204 No Content` for successful deletion
  - `404 Not Found` for missing resources

### Standard CRUD Endpoints
For each resource, implement these standard endpoints:
```
GET    /api/v1/[resources]           # List all (with pagination)
POST   /api/v1/[resources]           # Create new
GET    /api/v1/[resources]/:id       # Get by ID
PUT    /api/v1/[resources]/:id       # Update by ID
DELETE /api/v1/[resources]/:id       # Delete by ID
```

### Response Format
All API responses must use the `ApiResponse<T>` wrapper:

```typescript
// Success response
ApiResponse.success<T>(data)

// Error response
ApiResponse.error<T>(errorMessage)
```

**Response Structure:**
```typescript
{
  isSuccess: boolean,
  data?: T,
  error?: string
}
```

---

## Error Handling Patterns

### Custom Exception Hierarchy
All exceptions extend `BaseException`:

```typescript
abstract class BaseException extends Error {
  statusCode: number;
  constructor(statusCode: number, message: string)
}
```

### Exception Types
- `NotFoundException` (404): Resource not found
- `InvalidModelException` (400): Validation errors
- `ConflictException` (409): Resource conflicts
- `UnauthorizeException` (401): Authentication errors

### Exception Usage Rules
1. **Always throw custom exceptions** in services, never generic `Error`
2. **Pass exceptions to next()** in controllers: `catch (err) { next(err); }`
3. **Global exception middleware** handles all exceptions automatically
4. **Include descriptive messages** in exception constructors

### Global Exception Middleware
- Must be registered **after** all routes
- Catches all unhandled exceptions
- Converts exceptions to standardized `ApiResponse.error()` format
- Returns appropriate HTTP status codes

---

## Data Transfer Objects (DTOs)

### DTO Naming
- **Request DTOs**: `[Resource]RequestDto`, `Create[Resource]RequestDto`
- **Response DTOs**: `[Resource]Dto`
- **Pagination DTOs**: `PaginationRequest`, `Pagination<T>`

### DTO Structure
```typescript
// Request DTO (for creating/updating)
export interface CreateResourceRequestDto {
  // Only fields that can be set by user
}

// Response DTO (what is returned)
export interface ResourceDto {
  id: string;  // Always include ID
  // All fields that should be exposed
}
```

### DTO Rules
1. **Separate request and response DTOs** - never return full request DTOs
2. **Always include `id`** in response DTOs
3. **Use interfaces**, not classes for DTOs
4. **Don't expose internal fields** (e.g., `__v`, `_id` from Mongoose)

---

## Service Layer Patterns

### Service Class Structure
```typescript
export class ResourceService {
  constructor() {}

  public async createResource(data: CreateResourceRequestDto): Promise<ResourceDto> {
    // Implementation
  }

  public async getAllResources(pagination: PaginationRequest): Promise<Pagination<ResourceDto>> {
    // Implementation
  }

  public async getResourceById(id: string): Promise<ResourceDto> {
    // Implementation
  }

  public async updateResourceById(id: string, data: Partial<CreateResourceRequestDto>): Promise<ResourceDto> {
    // Implementation
  }

  public async deleteResourceById(id: string): Promise<boolean> {
    // Implementation
  }
}
```

### Service Rules
1. **All database operations** happen in services
2. **Return DTOs**, not Mongoose documents
3. **Throw custom exceptions** for error cases
4. **Use mapper** for converting models to DTOs when using mapping profiles
5. **Handle pagination** using `PaginationRequest` and return `Pagination<T>`
6. **Use default pagination constants** (`DEFAULT_LIMIT`, `DEFAULT_INDEX`)

### Service Registration
Services are registered in `services/index.service.ts`:

```typescript
class V1Service {
  Resource = new ResourceService();
  // ... other services
}
export const v1Service = new V1Service();
```

**Access pattern**: `v1Service.Resource.methodName()`

---

## Controller Layer Patterns

### Controller Class Structure
```typescript
export class ResourceController {
  public async create(
    req: Request<{}, {}, CreateResourceRequestDto>,
    res: Response,
    next: NextFunction
  ) {
    try {
      const body = req.body;
      const resource = await v1Service.Resource.createResource(body);
      res.status(201).json(ApiResponse.success<ResourceDto>(resource));
    } catch (err) {
      next(err);
    }
  }
  // ... other methods
}
```

### Controller Rules
1. **Extract request data** from `req.body`, `req.params`, `req.query`
2. **Call service methods** - never access models directly
3. **Wrap responses** in `ApiResponse.success<T>()`
4. **Use try-catch** and pass errors to `next(err)`
5. **Set appropriate HTTP status codes** (201 for create, 200 for get/update, 204 for delete)
6. **Type request generics** properly: `Request<Params, ResBody, ReqBody, ReqQuery>`

### Controller Registration
Controllers are registered in `controllers/v1/index.ts`:

```typescript
class V1Controller {
  Resource = new ResourceController();
  // ... other controllers
}
export const v1Controller = new V1Controller();
```

**Access pattern**: `v1Controller.Resource.methodName`

---

## Database/Model Patterns

### Mongoose Model Structure
```typescript
// 1. Define interface extending Document
export interface IResource extends Document {
  field1: string;
  field2: number;
}

// 2. Define schema
const ResourceSchema = new Schema<IResource>({
  field1: { type: String, required: true },
  field2: { type: Number, required: true },
});

// 3. Export model using TableName enum
export const Resource: Model<IResource> = mongoose.model(
  TableName.Resource,
  ResourceSchema
);
```

### Model Rules
1. **Use TypeScript interfaces** extending `Document` for type safety
2. **Use `TableName` enum** for collection names (prevents typos)
3. **Define required fields** explicitly in schema
4. **Use enums** for enum fields: `{ type: String, enum: Object.values(EnumName), required: true }`
5. **Export both interface and model** for reuse

### Database Operations
- **Create**: `new Model(data).save()` or `Model.insertMany([...])`
- **Read**: `Model.find()`, `Model.findById(id)`, `Model.findOne()`
- **Update**: `Model.findByIdAndUpdate(id, data, { new: true })`
- **Delete**: `Model.findByIdAndDelete(id)`
- **Count**: `Model.countDocuments({})`

### Pagination in Queries
```typescript
const limit = pagination.limit ?? DEFAULT_LIMIT;
const index = pagination.index ?? DEFAULT_INDEX;
const items = await Model.find()
  .skip(limit * index)
  .limit(limit);
const total = await Model.countDocuments({});
```

---

## Mapping Patterns

### Mapping Profile Structure
Mapping profiles convert Mongoose documents to DTOs:

```typescript
// In mapping/profiles/ResourceProfile.ts
export const resourceToDtoProfile = new Profile<IResource, ResourceDto>((resource) => ({
  id: resource.id,
  field1: resource.field1,
  field2: resource.field2,
}));
```

### Profile Registration
1. **Create profile** in `mapping/profiles/[Resource]Profile.ts`
2. **Add profile name** to `MappingProfileName` enum
3. **Register profile** in `mapping/Mapper.ts`:
   ```typescript
   mapper.register(MappingProfileName.resourceToDtoProfile, resourceToDtoProfile);
   ```

### Using Mapper
```typescript
// Single object
const dto = mapper.map<IResource, ResourceDto>(
  MappingProfileName.resourceToDtoProfile,
  resource
);

// Array
const dtos = mapper.mapArray<IResource, ResourceDto>(
  MappingProfileName.resourceToDtoProfile,
  resources
);
```

### Mapping Rules
1. **Use mapper** when you have complex transformations or want consistency
2. **Manual mapping** is acceptable for simple cases (just copying fields)
3. **Always map `_id` to `id`** in DTOs
4. **Don't expose internal Mongoose fields** (`__v`, etc.)

---

## Validation Patterns

### Custom Validation Decorator
The project uses a custom `@CheckValidation()` decorator:

```typescript
@CheckValidation()
public async createResource(data: CreateResourceRequestDto) {
  // Method implementation
}
```

### Validation Rules
1. **Apply decorator** to service methods that accept DTOs
2. **Use class-validator** decorators in DTO classes (if using classes)
3. **Validation happens automatically** before method execution
4. **Throws `InvalidModelException`** (400) on validation failure

### Validation Decorator Implementation
- Validates all object arguments passed to the method
- Uses `class-validator`'s `validate()` function
- Throws `InvalidModelException` with error details

---

## Routing Patterns

### Route File Structure
```typescript
import { Router } from "express";
import { v1Controller } from "../../controllers/v1";

const route = Router();

route.get("/", v1Controller.Resource.getAll);
route.post("/", v1Controller.Resource.create);
route.get("/:id", v1Controller.Resource.getById);
route.put("/:id", v1Controller.Resource.updateById);
route.delete("/:id", v1Controller.Resource.deleteById);

export default route;
```

### Route Registration
Routes are registered in `routes/v1/index.route.ts`:

```typescript
import resourceRoute from "./resource.route";

const route = Router();
route.use("/resources", resourceRoute);
export default route;
```

### Route Rules
1. **Use kebab-case** for route paths
2. **Use plural nouns** for resource names
3. **Directly bind controller methods** - no wrapper functions needed
4. **Handle file uploads** with multer middleware before controller method
5. **Export default** the router

### File Upload Routes
```typescript
import multer from "multer";
const storage = multer.memoryStorage();
const upload = multer({ storage });

route.post(
  "/upload",
  upload.single("file"),
  async (req: Request, res: Response, next: NextFunction) => {
    await v1Controller.Resource.uploadByExcel(req, res, next);
  }
);
```

---

## Middleware Patterns

### Global Exception Middleware
- **Must be registered last** (after all routes)
- **Catches all exceptions** passed via `next(err)`
- **Converts to ApiResponse format**
- **Returns appropriate status codes**

### Middleware Registration Order
```typescript
app.use(cors());
app.use(express.json());
app.use("/api/v1", v1Routes);
app.use(globalExceptionMiddleware);  // Must be last
```

---

## Configuration Patterns

### Environment Configuration
Configuration is loaded from `.env` files based on `NODE_ENV`:

```typescript
// config/dotenv.ts
const ENV = process.env.NODE_ENV || "development";
dotenv.config({ path: `.${ENV}.env` });

export const config = {
  env: ENV,
  port: process.env.PORT || 3000,
  connectionString: process.env.CONNECTION_STRING || "",
};
```

### Configuration Rules
1. **Use centralized config** object exported from `config/dotenv.ts`
2. **Provide defaults** for all configuration values
3. **Load environment-specific** `.env` files (`.development.env`, `.production.env`)
4. **Never hardcode** configuration values

### Database Configuration
Database connection is handled in `config/mongose.config.ts`:

```typescript
export const connectDB = async () => {
  await mongoose.connect(config.connectionString);
  // Error handling
};
```

**Rules:**
- Call `connectDB()` in `src/index.ts` before starting server
- Handle connection errors and exit process on failure

---

## TypeScript Configuration

### Compiler Options
- **Target**: ES2017 (supports async/await)
- **Module**: CommonJS (Node.js)
- **Strict mode**: Enabled
- **Decorators**: Enabled (`experimentalDecorators`, `emitDecoratorMetadata`)
- **Path aliases**: `@src/*` maps to `./src/*`

### TypeScript Rules
1. **Use strict mode** - enables all strict type checking
2. **Enable decorators** - required for validation and mapping
3. **Use path aliases** for cleaner imports (optional)
4. **Type all function parameters and return types**
5. **Use interfaces** for DTOs and model definitions
6. **Use generics** for reusable types (e.g., `ApiResponse<T>`, `Pagination<T>`)

---

## File Upload Patterns

### Excel File Upload
The project uses `ExcelExtractionService` for processing Excel files:

```typescript
const excelService = new ExcelExtractionService<DtoType>();
const data = excelService.extractDataFromExcel(req.file);
```

### File Upload Rules
1. **Use multer** with `memoryStorage()` (files in memory, not disk)
2. **Check for file existence** before processing
3. **Use generic ExcelExtractionService** with DTO type parameter
4. **Extract data** and pass to service's bulk create method
5. **Return array of created resources**

### Excel Extraction Service
- Reads Excel files from buffer
- Converts first sheet to JSON array
- Supports generic type parameter for type safety
- Throws errors on file processing failures

---

## Pagination Patterns

### Pagination Request
```typescript
export interface PaginationRequest {
  index?: number;  // Page number (0-based)
  limit?: number;  // Items per page
}
```

### Pagination Response
```typescript
export type Pagination<T> = {
  items: T[];
  index: number;
  total: number;
};
```

### Pagination Constants
```typescript
export const DEFAULT_LIMIT = 15;
export const DEFAULT_INDEX = 0;
```

### Pagination Rules
1. **Use optional parameters** in `PaginationRequest` (index, limit)
2. **Apply defaults** using nullish coalescing: `limit ?? DEFAULT_LIMIT`
3. **Calculate skip**: `skip(limit * index)`
4. **Return total count** for frontend pagination UI
5. **Always return `Pagination<T>`** for list endpoints

---

## Exception Patterns

### Base Exception
All custom exceptions extend `BaseException`:

```typescript
export abstract class BaseException extends Error {
  statusCode: number;
  constructor(statusCode: number, message: string) {
    super(message);
    this.statusCode = statusCode;
    this.name = this.constructor.name;
  }
}
```

### Standard Exceptions
- **NotFoundException** (404): Resource not found
- **InvalidModelException** (400): Validation errors
- **ConflictException** (409): Resource conflicts (duplicates, etc.)
- **UnauthorizeException** (401): Authentication/authorization errors

### Exception Usage
```typescript
// In services
if (!resource) {
  throw new NotFoundException(`Resource with id '${id}' not found`);
}

// In controllers
try {
  // ... operation
} catch (err) {
  next(err);  // Pass to global exception middleware
}
```

### Exception Rules
1. **Always use custom exceptions** - never throw generic `Error`
2. **Include descriptive messages** with context (e.g., resource ID)
3. **Let global middleware handle** exception-to-response conversion
4. **Use appropriate status codes** for each exception type

---

## Additional Patterns and Best Practices

### Import Organization
1. **External libraries first** (express, mongoose, etc.)
2. **Internal modules second** (relative imports)
3. **Group by type**: libraries, then controllers, then services, then models, then types

### Async/Await
- **Always use async/await** instead of promises
- **Wrap in try-catch** in controllers
- **Let errors propagate** to global exception middleware

### Type Safety
- **Type all function parameters** and return types
- **Use generics** for reusable components
- **Use TypeScript interfaces** for DTOs and models
- **Avoid `any` type** - use `unknown` if type is truly unknown

### Code Organization
- **One class per file**
- **One interface/type per file** (or group related types)
- **Export default** for route files
- **Named exports** for classes, functions, and types

### Error Messages
- **Use descriptive error messages** with context
- **Include resource identifiers** in error messages (IDs, names, etc.)
- **Use consistent message format** across the application

---

## Summary Checklist

When creating a new resource/feature, ensure:

- [ ] Create DTOs in `dtos/[Resource].dto.ts`
- [ ] Create model in `models/[Resource].ts` with interface and schema
- [ ] Add collection name to `TableName` enum
- [ ] Create service in `services/[resource].service.ts`
- [ ] Register service in `services/index.service.ts`
- [ ] Create controller in `controllers/v1/[resource].controller.ts`
- [ ] Register controller in `controllers/v1/index.ts`
- [ ] Create route in `routes/v1/[resource].route.ts`
- [ ] Register route in `routes/v1/index.route.ts`
- [ ] Implement standard CRUD methods
- [ ] Use `ApiResponse.success<T>()` for responses
- [ ] Throw custom exceptions for errors
- [ ] Handle pagination for list endpoints
- [ ] Use mapper for model-to-DTO conversion (if complex)
- [ ] Add validation decorator to service methods
- [ ] Follow naming conventions throughout

