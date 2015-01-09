#!/bin/bash

BASE_DIR=/var/lib/docker/container-ext-filesystems/
CONTAINER_IDS=`sudo docker ps -a | awk '{ print $1}' | grep -v CONTAINER`
USED_FS_IDS=();
AVAILABLE_IDS=();

for CONTAINER in $CONTAINER_IDS
do
	USED_FS_IDS=(${USED_FS_IDS[@]} `sudo docker inspect -f='{{.Name}}' $CONTAINER | awk -F"-" '{print $NF }'`)
done

echo "Used ext fs"
echo ${USED_FS_IDS[@]}

for DIRECTORY in `find ${BASE_DIR} -maxdepth 1 -type d`
do
	if [ ! "${DIRECTORY}" == "${BASE_DIR}" ]; then
		AVAILABLE_IDS=(${AVAILABLE_IDS[@]} `basename ${DIRECTORY}`)
	fi
done

echo "Avail ext fs"
echo ${AVAILABLE_IDS[@]}

# merge all together
not_in_a=()

for item1 in "${AVAILABLE_IDS[@]}"; do
    for item2 in "${USED_FS_IDS[@]}"; do
        [[ $item1 == "$item2" ]] && continue 2
    done

    # If we reached here, nothing matched.
    not_in_a+=( "$item1" )
done

echo "to delete"
echo ${not_in_a[@]}

for EXTFS in ${not_in_a[@]}
do
	echo "delete ${BASE_DIR}${EXTFS}"
	du -sh ${BASE_DIR}${EXTFS}
	rm -rf ${BASE_DIR}${EXTFS}
done
