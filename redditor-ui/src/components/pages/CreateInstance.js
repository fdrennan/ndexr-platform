import React from "react";
import Instance from "../instances/Instance";
import InstanceForm from "../instances/InstanceForm";
import Navbar from "../layout/Navbar";
import useStyles from "../../Theme";

import Grid from "@material-ui/core/Grid";

const CreateInstance = () => {
  const classes = useStyles();
  return (
    <div>
      <Navbar />
      <Grid
        item
        xs={12}
        sm={12}
        md={12}
        justify="center"
        container
        component="main"
        // className={classes.root}
      >
        <InstanceForm />
        <Instance />
      </Grid>
    </div>
  );
};

export default CreateInstance;
