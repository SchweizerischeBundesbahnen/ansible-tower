# ansible-tower
Ansible Tower dockerized
Das Image basiert auf https://github.com/ybalt/ansible-tower.

Es müssen dabei Ordner für settings, postgres, daten und logs gemountet werden. Wenn diese Mounts fehlen, startet das Image nicht.

### /var/lib/postgresql/9.4/main

* Mount für Postgresdatenbank
* kann mit "docker-compose ansible-tower run intialize" initialisiert, sofern der Ordner und /var/lib/awx leer sind

### /var/lib/awx
* Mount für awx-Daten
* kann mit "docker-compose ansible-tower run intialize" initialisiert, sofern der Ordner und /var/lib/postgresql/9.4/main leer sind

### /etc/tower
* Settings, müssen vorhanden sein und können nicht gebootstrappt werdne
* conf.d/ha.py wird beim "initialize"-Befehl kopiert, da die ID in Sync mit der DB sein muss

### /var/log/apache2, /var/log/tower
* Mounts für logs


## Starten des Ansible-Towers.
Docker und Docker-Compose müssen installiert sein.



1. Clonen des Settings-Repos
```
git clone https://code.sbb.ch/scm/~u217229/deploy-t-instance.git
```

2. Beim ersten Start: Bootstrappen
```
cd deploy-t-instance
docker-compose ansible-tower run intialize
```

3. Starten des Tower
```
cd deploy-t-instance
docker-compose ansible-tower up -d
```

4. [Optional] Umsetzen des Admin-Passworts
```
docker exec -it deploytinstance_ansible-tower_1 tower-manage changepassword admin
docker exec -it deploytinstance_ansible-tower_1 tower-manage changepassword admin
```