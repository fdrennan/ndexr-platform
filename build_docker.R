library(glue)
library(uuid)

DUMMY = UUIDgenerate()

system(glue('docker build -t redditorapi --build-arg DUMMY={DUMMY} --file ./DockerfileApi .'))
system(glue('docker build -t rpy --build-arg DUMMY={DUMMY} --file ./DockerfileRpy .'))
system(glue('docker build -t redditorui --build-arg DUMMY={DUMMY} --file ./DockerfileUi .'))
system(glue('docker build -t redditorapp --build-arg DUMMY={DUMMY} --file ./DockerfileShiny .'))
docker build -t rpy --file ./DockerfileRpy .