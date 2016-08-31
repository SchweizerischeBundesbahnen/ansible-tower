# ansible-tower
Ansible Tower dockerized
Das Image basiert auf https://github.com/ybalt/ansible-tower , mit folgendem Unterschied
Die Mounts sind statt unter /certs nun unter /settings .

Laufen des Ansible-Towers.

1. Named-Data-Ordner erstellen mit
```
settings/certs/deploy.sbb.ch_cer.pem
settings/certs/deploy.sbb.ch_privatekey.pem
settings/license
settings/ldap.py
settings/remote_host_headers.py
settings/settings.py
```
Siehe Ordner bootstrapping.

2. Container erstellen mit docker-compose
```
cd /etc/
git clone https://code.sbb.ch/scm/kd_wzu/ansibletower-docker.git wzu-docker
ln -s  /etc/wzu-docker/_scripts/init-compose/compose-init-script.sh /etc/init.d/deploy-t
chkconfig deploy-t on
service deploy-t init
```

Die Dateien von /settings werden nach /etc/tower kopiert.

```
/settings/certs/domain.crt  - copied to /etc/tower/tower.cert
/settings/certs/domain.key  - copied to /etc/tower/tower.key
/settings/license           - copied to /etc/tower/license
/settings/settings.py       - copied to /etc/tower/settings.py
```
SERVER_NAME env sollte für HTTPS angegeben werden (Zertifikat sollte valide sein)

/awx wird für Laufzeitdaten in den Container gelinkt und beinhaltet nachher folgende Daten
```
/awx                        - linked in /var/lib/awx
/var/lib/awx/job_status     - beinhaltet logs der ansible runs
/var/lib/awx/projects       - beinhaltet Projektrepos
/var/lib/awx/initialized    - flag ob der tower initialisiert wurde
```

Bei einem Hard-Reset des Towers, muss nur die Datei /var/lib/awx/initialized gelöscht werden.

Intiale Credentials: user:admin pass:000
Passwort für alle anderen Services '000'

Limitations:
Alles ist aktuell lokal.

Bei Neustart von Container gehen alle Daten bis auf DB  verloren.