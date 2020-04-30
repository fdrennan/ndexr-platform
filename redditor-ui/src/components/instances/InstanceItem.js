import React, { useContext, useState } from "react";
import { Collapse } from "react-collapse";

import InstanceContext from "../../context/instance/instanceContext";
import SecurityGroupContext from "../../context/securitygroup/securityGroupContext";
import Grid from "@material-ui/core/Grid";
import Typography from "@material-ui/core/Typography";
import useStyles from "../../Theme";
import Button from "@material-ui/core/Button";
import ButtonGroup from "@material-ui/core/ButtonGroup";
import TextField from "@material-ui/core/TextField";
import Box from "@material-ui/core/Box";
import { makeStyles } from "@material-ui/core/styles";

const pageStyles = makeStyles(theme => ({
  root: {
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    "& > *": {
      margin: theme.spacing(1)
    }
  },
  border: {
    borderWidth: "10px",
    border: "solid"
  }
}));

const InstanceItem = ({ instance }) => {
  const pageClasses = pageStyles();
  const instanceContext = useContext(InstanceContext);
  const securityGroupContext = useContext(SecurityGroupContext);
  const {
    modifyInstance,
    clearCurrentInstance,
    getInstances
  } = instanceContext;

  const { createKeyFile } = securityGroupContext;
  const classes = useStyles();
  const [hidden, setHidden] = useState(false);

  // useEffect(() => {
  //   console.log(instance);
  // }, []);
  const {
    image_id,
    instance_id,
    instance_type,
    state,
    instance_storage,
    public_ip_address,
    launch_time,
    login,
    key_name
  } = instance;

  const [instanceType, setInstanceType] = useState("");

  const onSetInstanceType = e => {
    e.preventDefault();
    setInstanceType(e.target.value);
    getInstances();
  };

  const onDelete = () => {
    modifyInstance(instance_id, "terminate");
    clearCurrentInstance();
    getInstances();
  };

  const buttonPush = () => {
    setHidden(!hidden);
  };

  const startServer = () => {
    modifyInstance(instance_id, "start");
    clearCurrentInstance();
    getInstances();
  };

  const stopServer = () => {
    modifyInstance(instance_id, "stop");
    clearCurrentInstance();
    getInstances();
  };

  const onModify = () => {
    modifyInstance(instance_id, "modify", instanceType);
    clearCurrentInstance();
    getInstances();
  };

  const displayPem = () => {
    createKeyFile(key_name);
  };

  return (
    <Box m={2} p={2} border={1} borderRadius={16}>
      <Grid>
        <Button
          type="submit"
          fullWidth
          variant="contained"
          color="secondary"
          className={classes.submit}
          onClick={buttonPush}
        >
          <div className={classes.card}>
            {!public_ip_address ? (
              <strong>{state[0].toUpperCase() + state.slice(1)}</strong>
            ) : (
              <strong>{public_ip_address}</strong>
            )}
          </div>
          <hr />
          <i className="fas fa-bars div-right" />
        </Button>
      </Grid>
      <Collapse isOpened={hidden}>
        <div className={pageClasses.root}>
          <ButtonGroup
            color="primary"
            aria-label="outlined primary button group"
          >
            <Box p={1}>
              <Button
                fullWidth
                variant="contained"
                className={classes.submit}
                onClick={startServer}
              >
                Start
              </Button>
            </Box>
            <Box p={1}>
              <Button
                fullWidth
                variant="contained"
                className={classes.submit}
                onClick={stopServer}
              >
                Stop
              </Button>
            </Box>
            <Box p={1}>
              <Button
                fullWidth
                variant="contained"
                className={classes.submit}
                onClick={onDelete}
              >
                Terminate
              </Button>
            </Box>
          </ButtonGroup>
        </div>
        <div>
          <TextField
            variant="outlined"
            margin="normal"
            required
            fullWidth
            id="instanceType"
            label="Instance Type"
            autoComplete="email"
            autoFocus
            type="text"
            placeholder="t2.xlarge"
            name="instanceType"
            value={instanceType}
            onChange={onSetInstanceType}
          />

          <Button
            fullWidth
            variant="contained"
            color="primary"
            className={classes.submit}
            onClick={onModify}
          >
            Modify
          </Button>
        </div>
        <code>{login}</code>
        {/*<ul className="list">*/}
        {public_ip_address && (
          // <li>
          <Typography>{`Public IP: ${public_ip_address}`}</Typography>
          // </li>
        )}
        {/*</ul>*/}
        {/*<ul className="list">*/}
        {launch_time && (
          // <li>
          <Typography>{`Launch Time: ${launch_time}`}</Typography>
          // </li>
        )}
        {state && (
          // <li>
          <Typography>{`Current State: ${state}`}</Typography>
          // </li>
        )}
        {instance_type && (
          // <li>
          <Typography>{`Instance Type: ${instance_type}`}</Typography>
          // </li>
        )}
        {instance_storage && (
          // <li>
          <Typography>{`Instance Storage: ${instance_storage}`}</Typography>
          // </li>
        )}
        {image_id && (
          // <li>
          <Typography>{`AMI Type: ${image_id}`}</Typography>
          // </li>
        )}

        {instance_id && (
          // <li>
          <Typography>{`Instance Id: ${instance_id}`}</Typography>
          // </li>
        )}
        <br />
        {key_name && (
          <Button
            onClick={displayPem}
            fullWidth
            variant="contained"
            color="primary"
            className={classes.submit}
          >
            Display PEM in Console - To see push [CMD+OPT+I] in Chrome
          </Button>
        )}
      </Collapse>
    </Box>
  );
};

export default InstanceItem;
