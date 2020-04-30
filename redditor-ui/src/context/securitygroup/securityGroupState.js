import React, { useReducer } from "react";
import axios from "axios";
import securityGroupContext from "./securityGroupContext";
import securityGroupReducer from "./securityGroupReducer";
import { GET_SECURITY_GROUP, CREATE_KEY_FILE } from "../types";

// BASE AMI: ami-0f75bb5fd5fa9f972
const R_HOST = "http://127.0.0.1";
const R_PORT = process.env.REACT_APP_PORT;

const SecurityGroupState = props => {
  const initialState = {
    securityGroups: null,
    keyFile: null
  };
  const [state, dispatch] = useReducer(securityGroupReducer, initialState);
  // Get Instance
  const getSecurityGroup = async () => {
    console.log("Inside getSecurityGroup");
    // dispatch({
    //   type: SET_LOADING,
    //   payload: true
    // });
    try {
      const res = await axios.get(`${R_HOST}:${R_PORT}/security_group_list`, {
        headers: {
          "Content-Type": "application/json"
        }
      });
      //
      const { data } = res.data;
      dispatch({
        type: GET_SECURITY_GROUP,
        payload: data
      });
    } catch (err) {
      console.error(err);
      console.log("getInstances");
    }
  };

  const createKeyFile = async keyName => {
    console.log("Inside createKeyFile");
    try {
      const res = await axios.get(`${R_HOST}:${R_PORT}/keyfile_create`, {
        headers: {
          "Content-Type": "application/json"
        },
        params: {
          keyname: keyName
        }
      });
      //
      const { data } = res.data;
      dispatch({
        type: CREATE_KEY_FILE,
        payload: data
      });

      console.log(`Store key below in this file: touch ~/${keyName}.pem`);
      console.log(data.keyfile);
      console.log(
        `Set correct permissions to use the file: chmod 400 ~/${keyName}.pem`
      );
      console.log(`Move into directory where file exists: cd ~`);
      console.log(
        `Run your ssh command to get into server: ssh "${keyName}.pem"...`
      );
    } catch (err) {
      console.error(err);
      console.log("getInstances");
    }
  };

  return (
    <securityGroupContext.Provider
      value={{
        securityGroups: state.securityGroups,
        keyFile: state.keyFile,
        getSecurityGroup,
        createKeyFile
      }}
    >
      {props.children}
    </securityGroupContext.Provider>
  );
};

export default SecurityGroupState;
