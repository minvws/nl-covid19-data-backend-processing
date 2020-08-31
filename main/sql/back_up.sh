#!/bin/bash

flyway -configFiles=/DatatinoProto/flyway.config migrate

flyway -configFiles=/DatatinoOrchestrator/flyway.config migrate 

flyway -configFiles=/VWSPROJECTCOVID/flyway.config migrate 

/opt/mssql-tools/bin/sqlcmd -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -Q "exec dbo.SP_RIVM_COVID_19_CASE_NATIONAL_BACK_UP"

/opt/mssql-tools/bin/bcp VWSSTATIC.RIVM_COVID_19_CASE_NATIONAL_BACK_UP out RIVM_COVID_19_CASE_NATIONAL_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSINTER.RIVM_COVID_19_CASE_NATIONAL in RIVM_COVID_19_CASE_NATIONAL_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP out POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP in POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.INFECTIOUS_PEOPLE out INFECTIOUS_PEOPLE.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.INFECTIOUS_PEOPLE in INFECTIOUS_PEOPLE.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# /opt/mssql-tools/bin/bcp VWSDEST.SUSPICIONS_GENERAL_PRACTITIONERS out SUSPICIONS_GENERAL_PRACTITIONERS.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

# /opt/mssql-tools/bin/bcp VWSDEST.SUSPICIONS_GENERAL_PRACTITIONERS in SUSPICIONS_GENERAL_PRACTITIONERS.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.SEWER_MEASUREMENTS out SEWER_MEASUREMENTS.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.SEWER_MEASUREMENTS in SEWER_MEASUREMENTS.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY out SEWER_MEASUREMENTS_PER_MUNICIPALITY.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY in SEWER_MEASUREMENTS_PER_MUNICIPALITY.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.SEWER_MEASUREMENTS_PER_REGION out SEWER_MEASUREMENTS_PER_REGION.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.SEWER_MEASUREMENTS_PER_REGION in SEWER_MEASUREMENTS_PER_REGION.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.SEWER_MEASUREMENTS_PER_RWZI out SEWER_MEASUREMENTS_PER_RWZI.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.SEWER_MEASUREMENTS_PER_RWZI in SEWER_MEASUREMENTS_PER_RWZI.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.REPRODUCTION_NUMBER out REPRODUCTION_NUMBER.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.REPRODUCTION_NUMBER in REPRODUCTION_NUMBER.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

/opt/mssql-tools/bin/bcp VWSSTATIC.RWZI_GMCODE out RWZI_GMCODE.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSSTATIC.RWZI_GMCODE in RWZI_GMCODE.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,
