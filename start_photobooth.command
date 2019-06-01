#!/bin/bash

lsof -n -i4TCP:3000 | grep LISTEN | awk '{ print $2 }' | xargs kill
rm tmp/pids/server.pid
cd
cd projects/photobooth
rails s

