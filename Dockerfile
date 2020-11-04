# Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
# Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

#  Docker image for recreating the VWS Dashboard database.

FROM mcr.microsoft.com/mssql-tools:latest

# git repository info
ARG PROTO_REPOSITORY
ARG ORCHESTRATOR_REPOSITORY
ARG VWSPROJECTCOVID_REPOSITORY
ARG BRANCH

# existing data will be put in:
ARG SQL_IN
ARG DB_IN
ARG USER_IN
ARG PASS_IN

# existing data will be pulled out of:
ARG SQL_OUT
ARG DB_OUT
ARG USER_OUT
ARG PASS_OUT

ENV PAT ${PAT}
ENV SQL_IN ${SQL_IN}
ENV SQL_OUT ${SQL_OUT}
ENV DB_IN ${DB_IN}
ENV DB_OUT ${DB_OUT}
ENV USER_IN ${USER_IN}
ENV PASS_IN ${PASS_IN}
ENV USER_OUT ${USER_OUT}
ENV PASS_OUT ${PASS_OUT}

# Get Flyway
RUN apt-get update && apt-get install -y git && apt-get install -y wget
RUN wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/6.5.5/flyway-commandline-6.5.5-linux-x64.tar.gz | tar xvz && ln -s `pwd`/flyway-6.5.5/flyway /usr/local/bin 

# Clone repos for database items
RUN git clone -b ${BRANCH} ${PROTO_REPOSITORY} &&\
    git clone -b ${BRANCH} ${ORCHESTRATOR_REPOSITORY} &&\
    git clone -b ${BRANCH} ${VWSPROJECTCOVID_REPOSITORY}

# Make Flyway configs
SHELL ["/bin/bash", "-c"]
RUN cd DatatinoOrchestrator && echo $' \n\
                             flyway.url=jdbc:sqlserver://${SQL_IN}:1433;database=${DB_IN} \n\
                             flyway.user=${USER_IN} \n\
                             flyway.password=${PASS_IN} \n\
                             flyway.schemas=DATATINO_ORCHESTRATOR \n\
                             flyway.locations= filesystem:DatatinoOrchestrator/sql/schemas, filesystem:DatatinoOrchestrator/sql/tables, filesystem:DatatinoOrchestrator/sql/functions, filesystem:DatatinoOrchestrator/sql/views, filesystem:DatatinoOrchestrator/sql/stored_procedures, filesystem:DatatinoOrchestrator/sql/data' > flyway.config && \
                             cd ../DatatinoProto && echo $' \n\
                             flyway.url=jdbc:sqlserver://${SQL_IN}:1433;database=${DB_IN} \n\
                             flyway.user=${USER_IN} \n\
                             flyway.password=${PASS_IN} \n\
                             flyway.schemas=DATATINO_PROTO \n\
                             flyway.locations= filesystem:DatatinoProto/sql/schemas, filesystem:DatatinoProto/sql/tables, filesystem:DatatinoProto/sql/views, filesystem:DatatinoProto/sql/stored_procedures' > flyway.config && \
                             cd ../VWSPROJECTCOVID && echo $' \n\
                             flyway.url=jdbc:sqlserver://${SQL_IN}:1433;database=${DB_IN} \n\
                             flyway.user=${USER_IN} \n\
                             flyway.password=${PASS_IN} \n\
                             flyway.schemas=VWSARCHIVE, VWSSTAGE, VWSSTATIC, VWSINTER, VWSDEST \n\
                             flyway.locations= filesystem:VWSPROJECTCOVID/main/sql/views, filesystem:VWSPROJECTCOVID/main/sql/migration_views, filesystem:VWSPROJECTCOVID/main/sql/functions, filesystem:VWSPROJECTCOVID/main/sql/tables/VWSARCHIVE, filesystem:VWSPROJECTCOVID/main/sql/tables/VWSSTATIC, filesystem:VWSPROJECTCOVID/main/sql/tables/VWSSTAGE, filesystem:VWSPROJECTCOVID/main/sql/tables/VWSINTER, filesystem:VWSPROJECTCOVID/main/sql/tables/VWSDEST, filesystem:VWSPROJECTCOVID/main/sql/data_import/static_data, filesystem:VWSPROJECTCOVID/main/sql/datatino_configuration/orchestration, filesystem:VWSPROJECTCOVID/main/sql/datatino_configuration/proto, filesystem:VWSPROJECTCOVID/main/sql/stored_procedures, filesystem:VWSPROJECTCOVID/main/sql/stored_procedures/vwsdest, filesystem:VWSPROJECTCOVID/main/sql/stored_procedures/vwsinter, filesystem:VWSPROJECTCOVID/main/sql/stored_procedures/archive/vwsstage, filesystem:VWSPROJECTCOVID/main/sql/stored_procedures/archive/vwsinter' > flyway.config

# get the back_up sh and make it executable
COPY main/sql/back_up.sh .
COPY resources/static_data/INHABITANTS_PER_MUNICIPALITY.csv .
RUN chmod 777 back_up.sh

# Run Flyway migrate and export/import the necessary data
ENTRYPOINT [ "./back_up.sh" ]