# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM registry.sbb.ch/kd_wzu/jenkins-slave-base
MAINTAINER Igor Masen <igor.masen2@sbb.ch>

ENV labels "nodejs"
ENV nodejs_version "v4.2.2"
ENV installer_url "https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh"
ENV was8version "8.5-OM08"


# Install js binaries for build
RUN yum update -q -y && yum install -q npm rubygems  -y && yum clean all -q

# Download and extract WAS 85 and create profile
RUN cd /opt \
        &&  wget -qO- ${filerurl}/was-${was8version}.tar.gz | tar xfz - \
        && mv /opt/was85/java_1.7_64 ${jenkinshome}/buildtools/ibm-jdk-was85 \
        && rm -rf /opt/was85 \
		&& chown -R ${appuser}:${appuser} ${jenkinshome} \
		&& ${jenkinshome}/buildtools/ibm-jdk-was85/bin/java -version

# Link custom keystore
RUN  cd ${jenkinshome}/buildtools \
	&& rm ./ibm-jdk-was85/jre/lib/security/cacerts \
	&& ln -s /opt/jdk/jre/lib/security/cacerts ./ibm-jdk-was85/jre/lib/security/cacerts \
	&& ls -l ./ibm-jdk-was85/jre/lib/security/cacerts

# Install nodejs
RUN curl -o- ${installer_url} | bash \
	&& source /root/.bashrc \
	&& nvm install ${nodejs_version} \
	&& nvm alias default ${nodejs_version} \
	&& cp -r /root/.nvm/versions/node/${nodejs_version}/{bin,lib,share} /usr/local \
	&& rm -f /bin/node \
	&& ln -s /usr/local/bin/node /bin/node


# Install packages for build
RUN npm install bower grunt grunt-cli gulp --silent && gem install bundle

# Add node binaries to path
RUN echo 'export PATH=$PATH:/node_modules/.bin' >> ${jenkinshome}/env.sh

# Set npm-registry to SBB proxy manually (https://issues.sbb.ch/browse/WZU-4080,https://issues.sbb.ch/browse/MWESERVICE-8786)
RUN echo 'registry = http://repo.sbb.ch/content/groups/mirror.npm' >> ${jenkinshome}/.npmrc 

# Chown jenkinshome
RUN chown -R ${appuser}:${appuser} ${jenkinshome}

# Run jenkins
CMD echo "export externalport=${externalport} host=${host}" >> ${jenkinshome}/env.sh && su - ${appuser} -c "${jenkinshome}/run.sh" && su - ${appuser} -c "source ${jenkinshome}/env.sh && /opt/jdk/bin/java -jar ${jenkinshome}/swarm-client.jar -executors ${executors} -fsroot ${jenkinshome} -master ${master} -name ${slavename} -username ${ciuser} -password ${cipassword} -labels ${labels} -mode exclusive"
