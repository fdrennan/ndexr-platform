import React, { useContext, useEffect } from "react";
import Spinner from "../layout/Spinner";
import InstanceContext from "../../context/instance/instanceContext";
import Grid from "@material-ui/core/Grid";
import Typography from "@material-ui/core/Typography";
import Box from "@material-ui/core/Box";

const Instance = () => {
  const instanceContext = useContext(InstanceContext);

  const { instances, getInstances, loading } = instanceContext;

  useEffect(() => {
    getInstances({ instances });

    // eslint-disable-next-line
  }, []);

  if (instances !== null && instances.length === 0 && !loading) {
    return <h4>Please add a contact</h4>;
  }

  if (instances === "false") {
    return (
      <Typography>
        <h1>Create an instance to get started</h1>
      </Typography>
    );
  }

  return (
    <Box m={2} component="main">
      {instances !== null && !loading ? (
        <Grid container>
          {JSON.parse(instances).map(data => {
            const {
              author,
              title,
              url,
              subreddit,
              thumbnail,
              created_utc,
              selftext
            } = data;
            return (
              <Grid
                xs={12}
                sm={6}
                direction="row"
                justify="space-between"
                alignItems="flex-start"
              >
                <Box m={1} border={1} padding={2}>
                  <Grid
                    container
                    direction="row"
                    justify="space-between"
                    alignItems="flex-start"
                  >
                    <Box m={1}>
                      <strong>Author:</strong>{" "}
                      <a
                        href={`http://reddit.com/u/${author}`}
                        target="_blank"
                        rel="noopener noreferrer"
                      >
                        {author}
                      </a>
                      <br />
                      <strong>Title:</strong> {title}
                      <br />
                      <strong>Created:</strong> {created_utc}
                      <br />
                      <strong>url:</strong>{" "}
                      <a href={url} target="_blank" rel="noopener noreferrer">
                        {title}
                      </a>
                      <br />
                      <strong>Subreddit:</strong>{" "}
                      <a
                        href={`http://reddit.com/r/${subreddit}`}
                        target="_blank"
                        rel="noopener noreferrer"
                      >
                        {subreddit}
                      </a>
                      <br />
                      <strong>Selftext:</strong>{" "}
                      {selftext &&
                        `${selftext.toString().slice(0, 500)}.......`}
                    </Box>

                    <a href={url} target="_blank" rel="noopener noreferrer">
                      <img src={thumbnail} alt="" />
                    </a>
                  </Grid>
                </Box>
              </Grid>
            );
          })}
        </Grid>
      ) : (
        <Spinner />
      )}
    </Box>
  );
};

export default Instance;
