# ansible-tower
Ansible Tower dockerized
Das Image basiert auf https://github.com/ybalt/ansible-tower , mit folgendem Unterschied
Die Mounts sind statt unter /certs nun unter /settings .

Laufen des Ansible-Towers.

1. Order erstellen mit 
1.1. settings/settings.py
1.2. settings/certs/domain.crt und settings/certs/domain.key
1.3. settings/license
2. awx

3. Container erstellen
```
# docker run -t -d -p 443:443 -p 8080:8080 -v ~/awx/:/var/lib/awx -v ~/settings:/settings -e SERVER_NAME=localhost --name=ansible-tower registry.sbb.ch/kd_wzu/ansible-tower
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