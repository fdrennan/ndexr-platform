import React from "react";

import useStyles from "../../Theme";
import Box from "@material-ui/core/Box";
import Grid from "@material-ui/core/Grid";
const SecurityGroupForm = () => {
  const classes = useStyles();

  return (
    <Grid justify="center" container component="main" className={classes.root}>
      <Grid xs={12} sm={6}>
        <Box>
          <img
            src={`http://${process.env.API_LOCATION}/api/comment_plot?limit=30000&granularity=1 minutes&timezone=MST&width=6&height=3.5`}
            alt="Smiley face"
            height="100%"
            width="100%"
          />
        </Box>
      </Grid>
      <Grid xs={12} sm={6}>
        <Box>
          <img
            src={`http://${process.env.API_LOCATION}/api/comment_plot?limit=30000&granularity=1 minutes&timezone=MST&table=submissions&width=6&height=3.5`}
            alt="Smiley face"
            height="100%"
            width="100%"
          />
        </Box>
      </Grid>
    </Grid>
  );
};

export default SecurityGroupForm;
