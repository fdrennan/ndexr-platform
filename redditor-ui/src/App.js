import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import SearchReddit from "./components/pages/SearchReddit";

import SubmissionState from "./context/instance/submissionState";

import Dashboard from "./components/pages/Dashboard";
import CssBaseline from "@material-ui/core/CssBaseline";
import "./sass/index.scss";

const App = () => {
  return (
    <CssBaseline>
      <SubmissionState>
        <Router>
          <Switch>
            <Route exact path="/" component={SearchReddit} />
            <Route exact path="/dashboard" component={Dashboard} />
          </Switch>
        </Router>
      </SubmissionState>
    </CssBaseline>
  );
};

export default App;
