WAS@Docker Prototyp
===================
Docker Image with WAS for integration tests etc.
https://issues.sbb.ch/browse/WZU-3256

Usage
-----
http://wzuscheduler.sbb.ch/job/kd.wzu.docker-was85.deploytest

	rm -fR wzu-docker
	git clone https://code.sbb.ch/scm/kd_wzu/wzu-docker.git
	cd wzu-docker
	git checkout develop
	
	cd base/base7/was85/configs
	chmod u+x deploy.sh
	./deploy.sh

Authors
-------

* u203257 (Christoph Glanzmann)
* u214892 (Christian Eichenberger)
