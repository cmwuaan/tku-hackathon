import { ExampleController } from "./example.controller";

class V1Controller {
  Example = new ExampleController();
}

export const v1Controller = new V1Controller();
