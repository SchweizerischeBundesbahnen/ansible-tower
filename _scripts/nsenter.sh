#! /bin/bash
nsenter -m -u -n -i -p -t `docker inspect --format='{{.State.Pid}}' $1` /bin/bash
