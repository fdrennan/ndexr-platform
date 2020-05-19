#' ec2_instance_script
#' @param postgres_password Password for airflow database
#' @param phone_number Number to sent you a ding. Message is pointless and nondescript
#' @param null_user Blank file for nothing to load on server.
#' @return A bash script
#' @export ec2_instance_script
ec2_instance_script <- function(postgres_password = '../../airflow',
                                phone_number      = NA,
                                null_user         = FALSE) {

  if(null_user) {
    null_user <- paste(
      '#!/bin/bash',
      'echo \'hello\' >> /tmp/tmpfile',
      sep = "\n"
    )
  }

  if(is.na(phone_number)) {
    phone_number = 5555555555
  } else {
    message(
      "Once the server is complete, you will receive a default message from textbelt.com"
    )
  }

  user_data = paste( '#!/bin/bash',
                     # Install R
                     'echo $\'deb https://cloud.r-project.org/bin/linux/ubuntu disco-cran35/\' >> /etc/apt/sources.list',
                     'sudo apt-get update',
                     'sudo apt-get install r-base -y',
                     'sudo apt-get install libcurl4-openssl-dev -y',
                     'sudo apt-get install libgit2-dev -y',
                     'sudo apt-get install libssl-dev -y',
                     'sudo apt-get install libssh2-1-dev -y',
                     'sudo apt-get install gdebi-core',
                     'sudo apt-get install python3-pip -y',
                     'sudo apt-get install libpq-dev -y',
                     'sudo apt-get install libxml2-dev -y',
                     'sudo /usr/bin/pip3 install virtualenv',
                     'sudo apt-get install python3-venv',
                     'wget https://download2.rstudio.org/server/trusty/amd64/rstudio-server-1.2.1335-amd64.deb',
                     'yes | sudo gdebi rstudio-server-1.2.1335-amd64.deb',
                     # Load airflow
                     'sudo apt install postgresql postgresql-contrib -y',
                     'CONF_FILE=$(find / -name "postgresql.conf" | grep main)',
                     'PG_FILE=$(find / -name "pg_hba.conf" | grep main)',
                     'echo "listen_addresses = \'*\'" >> $CONF_FILE',
                     'echo "host    all             all             0.0.0.0/0               md5" >> $PG_FILE',
                     'echo "host    all             all             ::/0                    md5" >> $PG_FILE',
                     'echo "#!/bin/bash" >> /tmp/update_pass',
                     paste0('echo  "sudo -u postgres -H -- psql -c \\"ALTER USER postgres PASSWORD \'',postgres_password ,'\'\\"" >> /tmp/update_pass'),
                     'sh /tmp/update_pass',
                     'service postgresql stop',
                     'service postgresql start',


                     # Send Notification
                     paste0(
                       '/usr/bin/curl -X POST https://textbelt.com/text \\
                              --data-urlencode phone=\'',phone_number,'\' \\
                              --data-urlencode message=\'Find Your Phone!\' \\
                              -d key=textbelt'
                     ),

                     # Something else
                     sep = "\n")

  message(user_data)

  user_data

}
