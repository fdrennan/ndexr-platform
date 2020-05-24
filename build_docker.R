library(glue)
library(uuid)

DUMMY = UUIDgenerate()

system(glue('docker build -t redditorapi --build-arg DUMMY={DUMMY} --file ./DockerfileApi .'))
system('docker build -t rpy --build-arg DUMMY={DUMMY} --file ./DockerfileRpy .')
system('docker build -t redditorui --build-arg DUMMY={DUMMY} --file ./DockerfileUi .')
system('docker build -t redditorapp --build-arg DUMMY={DUMMY} --file ./DockerfileShiny .')
