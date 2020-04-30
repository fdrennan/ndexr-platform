import { GET_SECURITY_GROUP, CREATE_KEY_FILE } from "../types";

export default (state, action) => {
  switch (action.type) {
    case GET_SECURITY_GROUP:
      console.log("GET_INSTANCES");
      console.log(action.payload);
      return {
        ...state,
        securityGroups: action.payload
      };
    case CREATE_KEY_FILE:
      console.log("CREATE_KEY_FILE");
      return {
        ...state,
        keyFile: action.payload
      };
    default:
      return state;
  }
};
