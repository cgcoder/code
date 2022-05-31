export interface Field {
  label?: string;
  type:
    | "string"
    | "object"
    | "date"
    | "boolean"
    | { arrayOf: Field["type"] }
    | "single-choice"
    | "multi-choice";
  allowedValues?: Options[];
  shape?: Record<string, Field>;
  required?: boolean;
  readonly?: boolean;
}

export interface Options {
  id: string;
  text: string;
}

export interface ModelShape extends Record<string, Field> {}

export function modelMap(
  prefix: string | null,
  model: Record<string, Field>
): Record<string, Field> {
  const keys = Object.keys(model);
  console.log(model);
  let result: Record<string, Field> = {};

  for (let i = 0; i < keys.length; i++) {
    const currentKey = prefix ? `${prefix}.${keys[i]}` : keys[i];
    result[currentKey] = model[keys[i]];
    const field = model[keys[i]];
    if (field.type === "object" || (field.type as any)?.arrayOf === "object") {
      const nextPrefix = prefix ? `${prefix}.${keys[i]}` : keys[i];
      const nextResult = modelMap(
        nextPrefix,
        model[keys[i]].shape as Record<string, Field>
      );
      console.log("nextResult", nextResult);
      result = { ...result, ...nextResult };
    }
  }

  return result;
}

export const modelShape: ModelShape = {
  name: {
    label: "Name of the student:",
    type: "string",
  },
  enrolled: {
    label: "Enrolled to school?",
    type: "boolean",
  },
  movies: {
    label: "Favorite Movies:",
    type: { arrayOf: "string" },
  },
  gender: {
    label: "Gender of the student",
    type: "single-choice",
    allowedValues: [],
  },
  friend: {
    type: "object",
    shape: {
      address: {
        label: "Name of the student:",
        type: "object",
        shape: {
          country: {
            type: "string",
          },
          state: {
            type: "string",
          },
        },
      },
    },
  },
};

export const modelValue = {
  name: "Gopinath",
  enrolled: true,
  movies: ["Stranger things", "Test"],
  friend: {
    name: "Raj",
  },
};
