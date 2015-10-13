export JAVA_HOME=/opt/jdk


if [ -z ${JAVA_XMX} ]; then
  JAVA_XMX=4096m
fi 

if [ -z ${JAVA_PERMSIZE} ]; then
  JAVA_PERMSIZE=512m
fi

echo $JAVA_XMX

JAVA_OPTS="-Dconfluence.home=/var/data/confluence -XX:+UnlockCommercialFeatures -XX:+FlightRecorder -XX:FlightRecorderOptions=defaultrecording=true,disk=true,repository=/var/data/confluence,maxage=1d -Xms${JAVA_XMX} -Xmx${JAVA_XMX} -XX:MaxPermSize=${JAVA_PERMSIZE} ${JAVA_OPTS} -Duser.timezone=Europe/Zurich -Datlassian.plugins.enable.wait=300 -Dfile.encoding=utf-8 -Dorg.apache.jasper.runtime.BodyContentImpl.LIMIT_BUFFER=false -Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -server"
CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=11090 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dconfluence.upgrade.recovery.file.enabled=false"
export JAVA_OPTS CATALINA_OPTS

# set the location of the pid file
if [ -z "$CATALINA_PID" ] ; then
    if [ -n "$CATALINA_BASE" ] ; then
        CATALINA_PID="$CATALINA_BASE"/work/catalina.pid
    elif [ -n "$CATALINA_HOME" ] ; then
        CATALINA_PID="$CATALINA_HOME"/work/catalina.pid
    fi
fi
export CATALINA_PID

PRGDIR=`dirname "$0"`
if [ -z "$CATALINA_BASE" ]; then
  if [ -z "$CATALINA_HOME" ]; then
    LOGBASE=$PRGDIR
    LOGTAIL=..
  else
    LOGBASE=$CATALINA_HOME
    LOGTAIL=.
  fi
else
  LOGBASE=$CATALINA_BASE
  LOGTAIL=.
fi

PUSHED_DIR=`pwd`
cd $LOGBASE
cd $LOGTAIL
LOGBASEABS=`pwd`
cd $PUSHED_DIR

echo ""
echo "Server startup logs are located in $LOGBASEABS/logs/catalina.out"

