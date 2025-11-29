export interface CreateExampleRequestDto {
  name: string;
  description: string;
  status: string;
}

export interface ExampleDto {
  id: string;
  name: string;
  description: string;
  status: string;
}

export interface ExampleAddRangeItemDto {
  name: string;
  description: string;
  status: string;
}

export interface ExampleAddRangeRequestDto {
  items: ExampleAddRangeItemDto[];
}

