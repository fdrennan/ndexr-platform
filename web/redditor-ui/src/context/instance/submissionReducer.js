import {
  GET_INSTANCES,
  SET_CURRENT_INSTANCE,
  CLEAR_CURRENT_INSTANCE,
  UPDATE_INSTANCE,
  FILTER_INSTANCES,
  CLEAR_INSTANCE_FILTER,
  INSTANCE_ERROR,
  CLEAR_INSTANCES,
  SET_LOADING
} from "../types";

export default (state, action) => {
  switch (action.type) {
    case SET_LOADING:
      return {
        ...state,
        loading: action.payload
      };
    case GET_INSTANCES:
      return {
        ...state,
        instances: action.payload,
        loading: false
      };
    case UPDATE_INSTANCE:
      return {
        ...state,
        instances: state.instances.map(contact =>
          contact._id === action.payload._id ? action.payload : contact
        ),
        loading: false
      };
    case CLEAR_INSTANCES:
      return {
        ...state,
        instances: null,
        filtered: null,
        error: null,
        instance: null
      };
    case SET_CURRENT_INSTANCE:
      return {
        ...state,
        instance: action.payload
      };
    case CLEAR_CURRENT_INSTANCE:
      return {
        ...state,
        instance: null
      };
    case FILTER_INSTANCES:
      return {
        ...state,
        filtered: state.instances.filter(contact => {
          const regex = new RegExp(`${action.payload}`, "gi");
          return contact.name.match(regex) || contact.email.match(regex);
        })
      };
    case CLEAR_INSTANCE_FILTER:
      return {
        ...state,
        filtered: null
      };
    case INSTANCE_ERROR:
      return {
        ...state,
        error: action.payload
      };
    default:
      return state;
  }
};
