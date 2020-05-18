sudo apt install postgresql postgresql-contrib -y
CONF_FILE=$(find / -name "postgresql.conf" | grep main)
PG_FILE=$(find / -name "pg_hba.conf" | grep main)
echo "listen_addresses = '*'" >> $CONF_FILE
echo "host    all             all             0.0.0.0/0               md5" >> $PG_FILE
echo "host    all             all             ::/0                    md5" >> $PG_FILE
echo "#!/bin/bash" >> /tmp/update_pass
echo  "sudo -u airflow -H -- psql -c \"ALTER USER airflow PASSWORD 'password'\"" >> /tmp/update_pass
sh /tmp/update_pass
service postgresql stop
service postgresql start
