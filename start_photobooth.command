#!/bin/bash

for (( ; ; ))
do
  status_code=$(curl --write-out %{http_code} --silent --head --output /dev/null localhost:3000/)
  if [[ "$status_code" -ne 200 ]] ; then
    lsof -n -i4TCP:3000 | grep LISTEN | awk '{ print $2 }' | xargs kill
    rm tmp/pids/server.pid
    cd
    cd projects/photobooth
    rails s
  fi
  sleep 5
done

