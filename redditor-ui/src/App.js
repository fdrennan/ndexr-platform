import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import CreateInstance from "./components/pages/CreateInstance";
// import About from "./components/pages/About";
// import Register from "./components/auth/Register";
// import Login from "./components/auth/Login";
import Alerts from "./components/layout/Alerts";
// import PrivateRoute from "./components/routing/PrivateRoute";
import AuthState from "./context/auth/AuthState";
import AlertState from "./context/alert/AlertState";
import InstanceState from "./context/instance/InstanceState";
import SecurityGroupState from "./context/securitygroup/securityGroupState";
import SecurityGroup from "./components/pages/SecurityGroup";
// import Scratch from "./components/scratch/Scratch";
import CssBaseline from "@material-ui/core/CssBaseline";
import "./sass/index.scss";

const App = () => {
  return (
    <CssBaseline>
      <AuthState>
        <SecurityGroupState>
          <InstanceState>
            <AlertState>
              <Router>
                <div>
                  <Alerts />
                  <Switch>
                    <Route exact path="/" component={CreateInstance} />
                    {/*<PrivateRoute exact path="/" component={CreateInstance} />*/}
                    <Route exact path="/security" component={SecurityGroup} />
                    {/*<Route exact path="/scratch" component={Scratch} />*/}
                    {/*<Route exact path="/about" component={About} />*/}
                    {/*<Route exact path="/register" component={Register} />*/}
                    {/*<Route exact path="/login" component={Login} />*/}
                  </Switch>
                </div>
              </Router>
            </AlertState>
          </InstanceState>
        </SecurityGroupState>
      </AuthState>
    </CssBaseline>
  );
};

export default App;
