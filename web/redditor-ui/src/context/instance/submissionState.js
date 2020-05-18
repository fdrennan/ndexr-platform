import React, { useReducer } from "react";
import axios from "axios";
import InstanceContext from "./submissionContext";
import instanceReducer from "./submissionReducer";
import { GET_INSTANCES, SET_LOADING } from "../types";

const SubmissionState = props => {
  const initialState = {
    key: null,
    limit: 5,
    instances: null,
    instance: null,
    filtered: null,
    error: null
  };

  const [state, dispatch] = useReducer(instanceReducer, initialState);

  // Get Submission
  const getInstances = async instance => {
    console.log("GET INSTANCES");

    const { key, limit } = instance;

    dispatch({
      type: SET_LOADING,
      payload: true
    });

    try {
      const res = await axios.get(
        `http://${process.env.REACT_APP_API_LOCATION}/api/find_posts`,
        {
          headers: {
            "Content-Type": "application/json"
          },
          params: {
            search_term: key,
            limit: limit
          }
        }
      );

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

  return (
    <InstanceContext.Provider
      value={{
        instances: state.instances,
        instance: state.instance,
        filtered: state.filtered,
        error: state.error,
        getInstances
      }}
    >
      {props.children}
    </InstanceContext.Provider>
  );
};

export default SubmissionState;
