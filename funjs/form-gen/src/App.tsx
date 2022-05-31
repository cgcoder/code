import React from "react";
import { Typography } from "@material-ui/core";
import { FormGen } from "./FormGen";
import { modelShape } from "./model";

const model = {
  name: "Gopi",
  enrolled: true,
};

function App() {
  return (
    <div className="App">
      <Typography variant="h5">Hello World!</Typography>
      <FormGen modelShape={modelShape} model={model} />
    </div>
  );
}

export default App;
