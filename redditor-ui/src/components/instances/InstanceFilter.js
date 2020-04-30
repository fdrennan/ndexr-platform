import React, { useContext, useRef, useEffect } from "react";
import InstanceContext from "../../context/instance/instanceContext";

const InstanceFilter = () => {
  const instanceContext = useContext(InstanceContext);
  const text = useRef("");

  const { filterInstances, clearFilter, filtered } = instanceContext;

  useEffect(() => {
    if (filtered === null) {
      text.current.value = "";
    }
  });

  const onChange = e => {
    if (text.current.value !== "") {
      filterInstances(e.target.value);
    } else {
      clearFilter();
    }
  };

  return (
    <form>
      <input
        ref={text}
        type="text"
        placeholder="Filter Instance..."
        onChange={onChange}
      />
    </form>
  );
};

export default InstanceFilter;
