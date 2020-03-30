FROM openjdk:8-jre

# Add the liquibase user and step in the directory
RUN adduser --system --home /liquibase --disabled-password --group liquibase
WORKDIR /liquibase

# Latest Liquibase Release Version
ARG LIQUIBASE_VERSION=3.8.7

# Download, install & Liquibase
RUN set -x \
  && curl -L https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz | tar -xzf -

# Set liquibase to executable
RUN chmod 755 /liquibase

RUN mkdir drivers

# Download Mysql Driver
ARG MYSQL_DRIVER_VERSION=8.0.19
RUN curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz | tar -xzf -
RUN mv mysql-connector*/mysql-connector-*.jar drivers/mysql-connector.jar \
	&& rm -rf mysql-connector-*

# Download Postgres Driver
ARG POSTGRESQL_DRIVER_VERSION=42.2.11
RUN curl -L https://jdbc.postgresql.org/download/postgresql-${POSTGRESQL_DRIVER_VERSION}.jar --output drivers/postgresql-connector.jar 

CMD ./liquibase \ 
	--changeLogFile=./db/changelog/db.changelog-master.yaml \ 
	--classpath=./drivers/${DB_TYPE}-connector.jar \
	--url=${DB_URL} --username=${DB_USERNAME} --password=${DB_PASSWORD} \
	update
