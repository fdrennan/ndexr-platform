import React, { useReducer } from "react";
import axios from "axios";
import InstanceContext from "./instanceContext";
import instanceReducer from "./instanceReducer";
import {
  GET_INSTANCES,
  SET_CURRENT_INSTANCE,
  CLEAR_CURRENT_INSTANCE,
  UPDATE_INSTANCE,
  FILTER_INSTANCES,
  CLEAR_INSTANCES,
  CLEAR_INSTANCE_FILTER,
  INSTANCE_ERROR,
  SET_LOADING
} from "../types";

// BASE AMI: ami-0f75bb5fd5fa9f972
const R_HOST = "http://host.docker.internal/";
const R_PORT = "api";
const InstanceState = props => {
  const initialState = {
    key: null,
    limit: 5,
    instances: null,
    instance: null,
    filtered: null,
    error: null
  };

  const [state, dispatch] = useReducer(instanceReducer, initialState);

  // Get Instance
  const getInstances = async instance => {
    console.log("GET INSTANCES");

    const { key, limit } = instance;

    dispatch({
      type: SET_LOADING,
      payload: true
    });

    try {
      const res = await axios.get(`http://${process.env.REACT_APP_HOST}/api/find_posts`, {
        headers: {
          "Content-Type": "application/json"
        },
        params: {
          key: key,
          limit: limit
        }
      });

      const { data } = res.data;

      dispatch({
        type: GET_INSTANCES,
        payload: data
      });
    } catch (err) {
      console.error(err);
      console.log("getInstances");
    }
  };

  // Add Contact
  const addInstance = async instance => {
    console.log("ADD INSTANCES");
    try {
      const { key, limit } = instance;
      console.log(`http://${process.env.REACT_APP_HOST}/api/create_instance`);
      await axios.get(`http://web/api/find_posts`, {
        headers: {
          "Content-Type": "application/json"
        },
        params: {
          key: key,
          limit: limit
        }
      });
    } catch (err) {
      console.log("addInstance");
      console.error(err);
    }
  };

  // Delete Contact
  const modifyInstance = async (id, modify, instanceType = "") => {
    try {
      await axios.get(`http://${process.env.REACT_APP_HOST}/api/instance_modify`, {
        headers: {
          "Content-Type": "application/json"
        },
        params: {
          user_token: localStorage.token,
          id,
          method: modify,
          instance_type: instanceType
        }
      });
    } catch (err) {
      console.error(err);
      console.log("deleteInstance");
      dispatch({
        type: INSTANCE_ERROR,
        payload: err.response.message
      });
    }
  };

  // Update Contact
  const updateInstance = async instance => {
    const config = {
      headers: {
        "Content-Type": "application/json"
      }
    };

    try {
      const res = await axios.put(
        `/api/contacts/${instance._id}`,
        instance,
        config
      );

      dispatch({
        type: UPDATE_INSTANCE,
        payload: res.data
      });
    } catch (err) {
      dispatch({
        type: INSTANCE_ERROR,
        payload: err.response.msg
      });
    }
  };

  // Clear Instance
  const clearContacts = () => {
    dispatch({ type: CLEAR_INSTANCES });
  };

  // Set Current Contact
  const setInstance = instance => {
    dispatch({ type: SET_CURRENT_INSTANCE, payload: instance });
  };

  // Clear Current Contact
  const clearCurrentInstance = () => {
    dispatch({ type: CLEAR_CURRENT_INSTANCE });
  };

  // Filter Instance
  const filterInstances = text => {
    dispatch({ type: FILTER_INSTANCES, payload: text });
  };

  // Clear Filter
  const clearFilter = () => {
    dispatch({ type: CLEAR_INSTANCE_FILTER });
  };

  return (
    <InstanceContext.Provider
      value={{
        instances: state.instances,
        instance: state.instance,
        filtered: state.filtered,
        error: state.error,
        addInstance,
        modifyInstance,
        setInstance,
        clearCurrentInstance,
        updateInstance,
        filterInstances,
        clearFilter,
        getInstances,
        clearContacts
      }}
    >
      {props.children}
    </InstanceContext.Provider>
  );
};

export default InstanceState;
