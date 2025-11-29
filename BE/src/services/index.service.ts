import { ExampleService } from "./example.service";

class V1Service {
  Example = new ExampleService();
}
export const v1Service = new V1Service();
