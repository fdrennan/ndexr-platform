import React, { useState, useContext, useEffect } from "react";
import InstanceContext from "../../context/instance/instanceContext";
import Button from "@material-ui/core/Button";
import TextField from "@material-ui/core/TextField";
import Typography from "@material-ui/core/Typography";
import Box from "@material-ui/core/Box";
import useStyles from "../../Theme";
import Grid from "@material-ui/core/Grid";
const InstanceForm = () => {
  const classes = useStyles();

  const instanceContext = useContext(InstanceContext);

  const { clearCurrentInstance, instance, getInstances } = instanceContext;

  const [currentInstance, setInstance] = useState({
    key: "covid",
    limit: "5"
  });

  useEffect(() => {
    if (instance !== null) {
      getInstances(instance);
    } else {
      setInstance({
        ...currentInstance
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [instanceContext, instance]);

  const { limit, key } = currentInstance;

  const onChange = e =>
    setInstance({ ...currentInstance, [e.target.name]: e.target.value });

  const onSubmit = e => {
    e.preventDefault();
    getInstances(currentInstance);
    clearAll();
  };

  const clearAll = () => {
    clearCurrentInstance();
  };

  return (
    <Box container p={1}>
      <form
        // className={classes.form}
        onSubmit={onSubmit}
      >
        <Grid container>
          <Grid
            xs={12}
            direction="row"
            justify="space-between"
            alignItems="center"
          >
            <Box p={1}>
              <Typography>
                <h1>Search Reddit</h1>
              </Typography>
            </Box>
          </Grid>
          <Grid
            xs={6}
            direction="row"
            justify="space-between"
            alignItems="center"
          >
            <Box p={0.5}>
              <TextField
                variant="outlined"
                margin="normal"
                required
                fullWidth
                id="key"
                label="Search Phrase"
                // autoComplete="key"
                autoFocus
                type="text"
                // placeholder="Instance Storage: 50"
                name="key"
                value={key}
                onChange={onChange}
              />
            </Box>
          </Grid>
          <Grid
            xs={6}
            direction="row"
            justify="space-between"
            alignItems="center"
          >
            <Box p={0.5}>
              <TextField
                variant="outlined"
                margin="normal"
                required
                fullWidth
                id="limit"
                label="Maximum results - up to 1000"
                // autoComplete="email"
                autoFocus
                type="text"
                name="limit"
                value={limit}
                onChange={onChange}
              />
            </Box>
          </Grid>
          <Button
            type="submit"
            fullWidth
            variant="contained"
            color="primary"
            className={classes.submit}
            type="submit"
            value={instance ? "Update Contact" : "Start Server"}
          >
            Run Query
          </Button>
        </Grid>
      </form>
    </Box>
  );
};

export default InstanceForm;
