Liquibase Docker
================

Project creates a docker image based on the latest liquibase to apply a liquibase changelog to any mysql or postgres database.


## How to use
*	Pull the image 
	`docker pull liquibase-docker`
*	Mount both liquibase properties file and change log files to the directory '/liquibase/resources'
	`docker run --mount type=bind,source="$(pwd)/resources",target=/liquibase/resources --network=host liquibase-docker`
## Test
    run the test bash file from the root directory
    `./test/build-test.sh`
