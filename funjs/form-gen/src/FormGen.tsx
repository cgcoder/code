import { ModelShape, Field, modelMap } from "./model";
import React from "react";
import { TextField, Checkbox, Typography } from "@material-ui/core";

export interface FormGenProps {
  modelShape: ModelShape;
  model: any;
}

export interface ControlProps {
  parentField?: string;
  index?: number;
  field: string;
  model: any;
  modelShape: ModelShape;
}

export const TextControl: React.FC<ControlProps> = ({
  field,
  model,
  modelShape,
}) => {
  const label = modelShape[field].label;
  return (
    <div
      style={{
        display: "flex",
        alignContent: "space-between",
        alignItems: "center",
      }}
    >
      <Typography variant="subtitle1" style={{ paddingRight: "20px" }}>
        {label}
      </Typography>
      <TextField value={model[field]} />
    </div>
  );
};

export const CheckControl: React.FC<ControlProps> = ({
  field,
  model,
  modelShape,
}) => {
  const label = modelShape[field].label;
  console.log(model[field]);
  return (
    <div
      style={{
        display: "flex",
        alignContent: "space-between",
        alignItems: "center",
      }}
    >
      <Checkbox checked={model[field]} />
      <Typography variant="subtitle1">{label}</Typography>
    </div>
  );
};

function isArray(f: Field): boolean {
  return typeof f.type === "object" && !!f.type.arrayOf;
}

export const renderField = (
  key: string,
  model: any,
  modelShape: ModelShape
) => {
  console.log(modelShape[key].type);
  if (isArray(modelShape[key])) {
    const arrayProp = model[key] as unknown[];
    return (
      <div key={key}>
        {arrayProp.map((item, index) => {
          return <li>{renderField(`${key}.${index}`, item, modelShape)}</li>;
        })}
      </div>
    );
  } else if (modelShape[key].type === "string") {
    return <TextControl field={key} model={model} modelShape={modelShape} />;
  } else if (modelShape[key].type === "boolean") {
    return <CheckControl field={key} model={model} modelShape={modelShape} />;
  }
};

export const FormGen: React.FC<FormGenProps> = ({ model, modelShape }) => {
  const keys = Object.keys(model);
  // console.log(modelMap(null, modelShape));
  return <div>{keys.map((key) => renderField(key, model, modelShape))}</div>;
};
