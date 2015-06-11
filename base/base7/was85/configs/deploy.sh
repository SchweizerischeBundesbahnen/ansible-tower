# init some variables
#IMAGE=schweizerischebundesbahnen/was85
IMAGE=registry-t.sbb.ch/was85:WZU-3257
RANDOMINT_WAS=`shuf -i 40000-65000 -n1`
RANDOMINT_SSH=`shuf -i 40000-65000 -n1`
RANDOMINT_WASADMIN=`shuf -i 40000-65000 -n1`
NAME=was85-$RANDOMINT_WAS
WAS_URL=http://v00964.sbb.ch:$RANDOMINT_WAS

# start container
sudo docker run  -p $RANDOMINT_SSH:22 -p $RANDOMINT_WAS:9080 -p $RANDOMINT_WASADMIN:9043  -d --name $NAME $IMAGE

# wait till was is up and running
RET=1
until [ ${RET} -eq 22 ]; do
    curl --output /dev/null --silent --head --fail $WAS_URL
    RET=$?
    echo .
    sleep 5
done



# run the deployment script startwzuself.sh in the Docker container (use ant to use sshexec)
# Auf dem Docker-Host muss ant installiert sein: yum install ant ant-jsch
ant -Dwas.host=v00964.sbb.ch -Dwas.sshport=${RANDOMINT_SSH} -Dwas.user=asrun -Dwas.password=asrun -buildfile build.xml install

echo "Docker available by ssh asrun@v00964.sbb.ch  -p ${RANDOMINT_SSH}"
echo "Admin console available at https://v00964.sbb.ch:${RANDOMINT_WASADMIN}/ibm/console/"
echo "Application availabla at  http://v00964.sbb.ch:${RANDOMINT_WAS}/wzuself/"

# do something.....
sleep 5000

# stop container
sudo docker stop $NAME
sudo docker rm $NAME