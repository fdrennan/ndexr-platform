import React, { useState, useContext, useEffect } from "react";
import AlertContext from "../../context/alert/alertContext";
import AuthContext from "../../context/auth/authContext";
import Button from "@material-ui/core/Button";
import CssBaseline from "@material-ui/core/CssBaseline";
import TextField from "@material-ui/core/TextField";
import Link from "@material-ui/core/Link";
import Paper from "@material-ui/core/Paper";
import Box from "@material-ui/core/Box";
import Grid from "@material-ui/core/Grid";
import Typography from "@material-ui/core/Typography";

import useStyles from "../../Theme";
function Copyright() {
  return (
    <Typography variant="body2" color="textSecondary" align="center">
      {"Copyright © "}
      <Link color="inherit" href="https://material-ui.com/">
        ndexr.com
      </Link>{" "}
      {new Date().getFullYear()}
      {"."}
    </Typography>
  );
}

const Register = props => {
  const alertContext = useContext(AlertContext);
  const authContext = useContext(AuthContext);

  const { setAlert } = alertContext;
  const { register, error, clearErrors, isAuthenticated } = authContext;
  const classes = useStyles();
  useEffect(() => {
    if (isAuthenticated) {
      props.history.push("/");
    }

    if (error === "User already exists") {
      setAlert(error, "danger");
      clearErrors();
    }
    // eslint-disable-next-line
  }, [error, isAuthenticated, props.history]);

  const [user, setUser] = useState({
    name: "",
    email: "",
    password: "",
    password2: ""
  });

  const { name, email, password, password2 } = user;

  const onChange = e => setUser({ ...user, [e.target.name]: e.target.value });

  const onSubmit = e => {
    e.preventDefault();
    if (name === "" || email === "" || password === "") {
      setAlert("Please enter all fields", "danger");
    } else if (password !== password2) {
      setAlert("Passwords do not match", "danger");
    } else {
      register({
        name,
        email,
        password
      });
    }
  };

  return (
    <Grid container component="main" className={classes.root}>
      <CssBaseline />
      <Grid item xs={false} sm={4} md={7} className={classes.image} />
      <Grid item xs={12} sm={8} md={5} component={Paper} elevation={6} square>
        <div className={classes.paper}>
          <h1>
            Account <span className="text-primary">Register</span>
          </h1>
          <form className={classes.form} onSubmit={onSubmit}>
            <label htmlFor="name">Name</label>
            <TextField
              variant="outlined"
              margin="normal"
              required
              fullWidth
              id="name"
              label="John Smith"
              name="name"
              autoComplete="email"
              value={name}
              onChange={onChange}
              autoFocus
            />
            <label htmlFor="name">Email Address</label>
            <TextField
              variant="outlined"
              margin="normal"
              required
              fullWidth
              id="email"
              label="abc@gmail.com"
              type="email"
              name="email"
              autoComplete="email"
              value={email}
              onChange={onChange}
              autoFocus
            />
            <label htmlFor="password">Password</label>
            <TextField
              variant="outlined"
              margin="normal"
              required
              fullWidth
              id="password"
              label="password"
              type="password"
              name="password"
              autoComplete="email"
              value={password}
              minLength="6"
              onChange={onChange}
              autoFocus
            />
            <label htmlFor="password2">Confirm Password</label>
            <TextField
              variant="outlined"
              margin="normal"
              required
              fullWidth
              id="password2"
              label="password"
              type="password"
              name="password2"
              value={password2}
              minLength="6"
              onChange={onChange}
              autoFocus
            />

            <Button
              type="submit"
              fullWidth
              variant="contained"
              color="primary"
              value="Register"
              className={classes.submit}
            >
              Complete Registration
            </Button>
            <Grid container>
              <Grid item className={classes.right}>
                <Link href="/login" variant="body2">
                  {"Already have an account? Log In"}
                </Link>
              </Grid>
            </Grid>
            <Box mt={5}>
              <Copyright />
            </Box>
          </form>
        </div>
      </Grid>
    </Grid>
  );
};

export default Register;
