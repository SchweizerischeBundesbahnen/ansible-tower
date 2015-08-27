FROM registry.sbb.ch/base8

MAINTAINER u214892@sbb.ch

#Environment Variables
ENV sonarversion 4.5.4

ENV idoffset 120
ENV appuser sonar
ENV datadir /var/data
ENV sonar_home /var/data/sonar
ENV PATH /usr/local/bin:/sbin:/usr/sbin:/usr/bin:/bin

RUN yum install -y git && yum clean all -q

# Create Data directory structure and add user jira to the image
RUN mkdir -p ${datadir} && adduser ${appuser} -U -u 1${idoffset} --home ${sonar_home} && mkdir -p ${sonar_home}/shared

# Get Sonar distro and unpack everything
RUN cd /opt && wget -q "http://dist.sonar.codehaus.org/sonarqube-${sonarversion}.zip"  -O sonarqube-${sonarversion}.zip && unzip sonarqube-${sonarversion}.zip && rm sonarqube-${sonarversion}.zip && ln -s sonarqube-${sonarversion} sonar && chown -R sonar:sonar sonar sonarqube-${sonarversion}
RUN sed -ri "s#wrapper.java.command=java#wrapper.java.command=/opt/jdk/jre/bin/java#g" /opt/sonar/conf/wrapper.conf
COPY configs/sonar.properties /opt/sonar/conf/sonar.properties

# Plugins as in production
# sonar-branding-plugin-0.5.jar
# SonarQube 5.1 in Core gewandert
#RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-branding-plugin/0.5/sonar-branding-plugin-0.5.jar

# sonar-checkstyle-plugin-2.1.jar
# SonarQube 4.5 verlangt >= 2.3
RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/java/sonar-checkstyle-plugin/2.3/sonar-checkstyle-plugin-2.3.jar

# sonar-cobertura-plugin-1.6.2.jar
# SonarQube 5.1 verlangt >= 1.6.3
RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-cobertura-plugin/1.6.3/sonar-cobertura-plugin-1.6.3.jar

# sonar-emma-plugin-1.3.jar
# This plugin is deprecated since SonarQube 4.2. Use JaCoCo instead for Java projects or the Android plugin to import Emma 2.0 reports.
#RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-emma-plugin/1.3/sonar-emma-plugin-1.3.jar

# sonar-findbugs-plugin-3.0.jar
# SonarQube 5.1 verlangt >= 3.2
RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/java/sonar-findbugs-plugin/3.2/sonar-findbugs-plugin-3.2.jar

# sonar-java-plugin-2.4.jar
# SonarQube 5.1 verlangt >= 3.1
RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/java/sonar-java-plugin/3.1/sonar-java-plugin-3.1.jar

# sonar-javascript-plugin-2.1.jar
# SonarQube 5.1 verlangt >= 2.4
RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/javascript/sonar-javascript-plugin/2.4/sonar-javascript-plugin-2.4.jar

# sonar-ldap-plugin-1.4.jar
RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-ldap-plugin/1.4/sonar-ldap-plugin-1.4.jar

# sonar-motion-chart-plugin-1.7.jar
RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-motion-chart-plugin/1.7/sonar-motion-chart-plugin-1.7.jar

# sonar-pmd-plugin-2.2.jar
# SonarQube 5.1 verlangt >= 2.3
RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/java/sonar-pmd-plugin/2.3/sonar-pmd-plugin-2.3.jar

# sonar-scm-activity-plugin-1.8.jar
# Wird im in 5.1 im SonarQube-Core ausgeliefert
RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/scm-activity/sonar-scm-activity-plugin/1.8/sonar-scm-activity-plugin-1.8.jar
# Dafür neu git und scm ausliefern
#RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-scm-svn-plugin/1.0/sonar-scm-svn-plugin-1.0.jar
#RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-scm-git-plugin/1.0/sonar-scm-git-plugin-1.0.jar

# sonar-sigmm-plugin-1.0.1.jar
# This plugin is deprecated because it is not compatible with SonarQube 4.2+.
#RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-sigmm-plugin/1.0.1/sonar-sigmm-plugin-1.0.1.jar

# sonar-sonargraph-plugin-3.3-SNAPSHOT.jar
RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-sonargraph-plugin/3.3/sonar-sonargraph-plugin-3.3.jar

# sonar-sqale-plugin-2.3.jar
# SonarQube 5.1 verlangt >= 2.5
# http://sonarqube.15.x6.nabble.com/DataBase-Migration-failed-td5019158.html
#RUN cd /opt/sonar/extensions/plugins && wget -q http://dist.sonarsource.com/sqale/download/sonar-sqale-plugin-2.5.jar

# sonar-views-plugin-2.5.jar
# SonarQube 5.1 verlangt >= 2.8
#RUN cd /opt/sonar/extensions/plugins && wget -q http://dist.sonarsource.com/views/download/sonar-views-plugin-2.7.jar

# sonar-web-plugin-2.2.jar
# SonarQube 5.1 verlangt >= 2.3
RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-web-plugin/2.3/sonar-web-plugin-2.3.jar

# / MWESERVICE-6014
# sonar-groovy-plugin-1.1.1.jar
RUN cd /opt/sonar/extensions/plugins && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-groovy-plugin/1.1.1/sonar-groovy-plugin-1.1.1.jar
# \ MWESERVICE-6014

# RUN cd /opt && wget -q http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/javascript/sonar-javascript-plugin/2.4/sonar-javascript-plugin-2.4.jar -O /opt/sonar/extensions/plugins/sonar-javascript-plugin-2.4.jar

RUN chown -R ${appuser}:${appuser} $sonar_home
USER sonar
ENV MYSQL_HOST localhost
ENV MYSQL_DBNAME sonar
ENV MYSQL_USER sonar
ENV MYSQL_PASSWORD sonartest

EXPOSE 8110 9110 10110
COPY configs/sonar.sh /opt/sonar/sonar.sh
CMD /opt/sonar/sonar.sh
