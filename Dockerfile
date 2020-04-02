FROM openjdk:8-jre

#install lates postges connector
RUN apt-get update && apt-get install -yq --no-install-recommends libpostgresql-jdbc-java jq

# Add the liquibase user and step in the directory
RUN adduser --system --home /liquibase --disabled-password --group liquibase
WORKDIR /liquibase
	
# Download, install & Latest Liquibase
RUN LIQUIBASE_VERSION=`curl -s https://api.github.com/repos/liquibase/liquibase/releases/latest | jq -r .tag_name | cut -c2-` \ 
	&& curl -L https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz \
	 | tar -xzf - && chmod 755 /liquibase

# Download latest mysql
ARG MYSQL_VERISON=8.0.19
RUN curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_VERISON}.tar.gz | tar -xzf - \
	&& mv ./mysql-connector-java-${MYSQL_VERISON}/mysql-connector-java-${MYSQL_VERISON}.jar mysql-connector-j.jar \
	&& rm -rf ./mysql-connector-java-${MYSQL_VERISON}


CMD ./liquibase --classpath=/usr/share/java/postgresql.jar:./mysql-connector-j.jar \
	--defaultsFile=./resources/liquibase.properties update
