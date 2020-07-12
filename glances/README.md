
# Glances

## Install

```
wget -O- https://bit.ly/glances | /bin/bash
```

Create a new unit by creating a file called `glances.service` in the `/etc/systemd/system/` folder.

```
sudo vim /etc/systemd/system/glances.service
```


```
[Unit]
Description=Glances
After=network.target

[Service]
ExecStart=/usr/local/bin/glances -w
Restart=on-abort
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

```.
sudo systemctl enable glances.service
sudo systemctl start glances.service
```