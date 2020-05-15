import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import SearchReddit from "./components/pages/SearchReddit";
import Alerts from "./components/layout/Alerts";
import AlertState from "./context/alert/AlertState";
import InstanceState from "./context/instance/InstanceState";

import Dashboard from "./components/pages/Dashboard";
import CssBaseline from "@material-ui/core/CssBaseline";
import "./sass/index.scss";

const App = () => {
  return (
    <CssBaseline>

          <InstanceState>
            <AlertState>
              <Router>
                  <Alerts />
                  <Switch>
                    <Route exact path="/" component={SearchReddit} />
                    <Route exact path="/dashboard" component={Dashboard} />
                  </Switch>
              </Router>
            </AlertState>
          </InstanceState>

    </CssBaseline>
  );
};

export default App;
