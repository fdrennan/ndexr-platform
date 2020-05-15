import React from "react";
import Submission from "../submissions/submission";
import SubmissionForm from "../submissions/SubmissionForm";
import Navbar from "../layout/Navbar";

import Grid from "@material-ui/core/Grid";

const SearchReddit = () => {
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
      >
        <SubmissionForm />
        <Submission />
      </Grid>
    </div>
  );
};

export default SearchReddit;
