#!/usr/bin/env bash

# Creates directories to be mounted to containers as volumes
mkdir ~/iq-data ~/nexus-data-ha ~/nexus-data-ha/java-prefs ~/nexus-data-ha/blobs

# Stands up test environment and builds nginix container to put our config in
#docker-compose up -d
cd nexus-ha
docker build --rm -t my-nexus-ha .
docker run -d -p 8081:8081 -v ~/nexus-data-ha/blobs:/opt/sonatype/sonatype-work/nexus3/blobs -v ~/nexus-data-ha/java-prefs:/opt/sonatype/sonatype-work/nexus3/javaprefs  --name nexusa -it my-nexus-ha
cd ..

until curl --fail --insecure http://localhost:8081; do 
  sleep 5
done

#import license and policies to IQ server
#./iq-server/config-iq.sh

#Create Docker repos and group
cd nexus-repository
./create.sh blobs.json
./run.sh myBlobs

./create.sh docker.json
./run.sh Docker

# ./create.sh maven.json
# ./run.sh Maven
echo "Install License! Then stop and go run the compose file"