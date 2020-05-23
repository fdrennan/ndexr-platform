library(biggr)

security_group_id <-
  security_group_list() %>%
  filter(group_name == Sys.getenv("SECURITY_GROUP_NAME")) %>%
  pull(group_id)


user_data <- paste("#!/bin/bash",
  "cd /home/ubuntu",
  "sudo apt update -y",
  "sudo apt install apt-transport-https ca-certificates curl software-properties-common -y",
  "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
  'sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"',
  "sudo apt update",
  "sudo apt install docker-ce -y",
  "sudo usermod -aG docker ubuntu",
  'sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose',
  "sudo chmod +x /usr/local/bin/docker-compose",
  "git clone https://github.com/fdrennan/ndexr-platform.git",
  "cd ndexr-platform",
  "sudo docker build -t redditorapi --file ./DockerfileApi .",
  "sudo docker build -t rpy --file ./DockerfileRpy .",
  "sudo docker build -t redditorui --file ./DockerfileUi .",
  sep = "\n"
)


instance_data <-
  ec2_instance_create(
    ImageId = Sys.getenv("AWS_SERVER_IMAGE"),
    InstanceType = Sys.getenv("AWS_SERVER_TYPE"),
    KeyName = Sys.getenv("PEM_NAME"),
    SecurityGroupId = security_group_id,
    InstanceStorage = Sys.getenv("AWS_SERVER_SIZE"),
    user_data = user_data
  )


con <- postgres_connector()

upload_data <- tibble(
  time_created = as.character(Sys.time()),
  private_ip_address = instance_data[[1]]$private_ip_address,
  image_id = Sys.getenv("AWS_SERVER_IMAGE"),
  instance_type = Sys.getenv("AWS_SERVER_TYPE"),
  key_name = Sys.getenv("PEM_NAME"),
  security_group_id = security_group_id,
  storage_side = Sys.getenv("AWS_SERVER_SIZE"),
  user_data = user_data
)


dbWriteTable(con,
  name = "redditor_servers",
  value = upload_data, append = TRUE
)

# library(glue)
# system(glue('ssh -i "/pem/{Sys.getenv("PEM_NAME")}.pem" {Sys.getenv("CONNECTION_PARAMS")} \'ls -la\''))
