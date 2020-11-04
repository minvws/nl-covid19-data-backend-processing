#!/bin/bash

# Start rolling out the datamodels
flyway -configFiles=/DatatinoProto/flyway.config migrate

flyway -configFiles=/DatatinoOrchestrator/flyway.config migrate 

flyway -configFiles=/VWSPROJECTCOVID/flyway.config migrate 

# Start loading the latest available data entries per destination table
# Back-Up General Practitioners
/opt/mssql-tools/bin/bcp VWSDEST.V_GENERAL_PRACTITIONERS_BACK_UP out V_GENERAL_PRACTITIONERS_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.SUSPICIONS_GENERAL_PRACTITIONERS in V_GENERAL_PRACTITIONERS_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Back Up Hospital Admissions
# National
/opt/mssql-tools/bin/bcp VWSDEST.V_HOSPITAL_ADMISSIONS_BACK_UP out V_HOSPITAL_ADMISSIONS_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.HOSPITAL_ADMISSIONS in V_HOSPITAL_ADMISSIONS_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Municipality
/opt/mssql-tools/bin/bcp VWSDEST.V_HOSPITAL_ADMISSIONS_PER_MUNICIPALITY_BACK_UP out V_HOSPITAL_ADMISSIONS_PER_MUNICIPALITY_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.HOSPITAL_ADMISSIONS_PER_MUNICIPALITY in V_HOSPITAL_ADMISSIONS_PER_MUNICIPALITY_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Back Up National data
/opt/mssql-tools/bin/bcp VWSDEST.V_RIVM_COVID_19_CASE_NATIONAL_BACK_UP out V_RIVM_COVID_19_CASE_NATIONAL_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSINTER.RIVM_COVID_19_CASE_NATIONAL in V_RIVM_COVID_19_CASE_NATIONAL_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Back Up Infectious People
/opt/mssql-tools/bin/bcp VWSDEST.V_INFECTIOUS_PEOPLE_BACK_UP out V_INFECTIOUS_PEOPLE_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.INFECTIOUS_PEOPLE in V_INFECTIOUS_PEOPLE_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Back Up Intensive Care Admissions
/opt/mssql-tools/bin/bcp VWSDEST.V_INTENSIVE_CARE_ADMISSIONS_BACK_UP out V_INTENSIVE_CARE_ADMISSIONS_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.INTENSIVE_CARE_ADMISSIONS in V_INTENSIVE_CARE_ADMISSIONS_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Back Up Positive Tested People
# National
/opt/mssql-tools/bin/bcp VWSDEST.V_POSITIVE_TESTED_PEOPLE_BACK_UP out V_POSITIVE_TESTED_PEOPLE_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.POSITIVE_TESTED_PEOPLE in V_POSITIVE_TESTED_PEOPLE_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Age Group
/opt/mssql-tools/bin/bcp VWSDEST.V_POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_BACK_UP out V_POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP in V_POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Municipality
/opt/mssql-tools/bin/bcp VWSDEST.V_POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY_BACK_UP out V_POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY in V_POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Back Up Reproduction Number
/opt/mssql-tools/bin/bcp VWSDEST.V_REPRODUCTION_NUMBER_BACK_UP out V_REPRODUCTION_NUMBER_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.REPRODUCTION_NUMBER in V_REPRODUCTION_NUMBER_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Back Up Results Per Region
/opt/mssql-tools/bin/bcp VWSDEST.V_RESULTS_PER_REGION_BACK_UP out V_RESULTS_PER_REGION_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.RESULTS_PER_REGION in V_RESULTS_PER_REGION_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Back Up Nursing Homes
/opt/mssql-tools/bin/bcp VWSDEST.V_NURSING_HOMES_TOTALS_BACK_UP out V_NURSING_HOMES_TOTALS_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.NURSING_HOMES_TOTALS in V_NURSING_HOMES_TOTALS_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# # Back Up RIVM Municipality File
/opt/mssql-tools/bin/bcp VWSDEST.V_RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE_BACK_UP out V_RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE in V_RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Back Up Sewer Measurements
# National
/opt/mssql-tools/bin/bcp VWSDEST.V_SEWER_MEASUREMENTS_BACK_UP out V_SEWER_MEASUREMENTS_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.SEWER_MEASUREMENTS in V_SEWER_MEASUREMENTS_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Municipality
/opt/mssql-tools/bin/bcp VWSDEST.V_SEWER_MEASUREMENTS_PER_MUNICIPALITY_BACK_UP out V_SEWER_MEASUREMENTS_PER_MUNICIPALITY_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY in V_SEWER_MEASUREMENTS_PER_MUNICIPALITY_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Region
/opt/mssql-tools/bin/bcp VWSDEST.V_SEWER_MEASUREMENTS_PER_REGION_BACK_UP out V_SEWER_MEASUREMENTS_PER_REGION_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.SEWER_MEASUREMENTS_PER_REGION in V_SEWER_MEASUREMENTS_PER_REGION_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# RWZI
/opt/mssql-tools/bin/bcp VWSDEST.V_SEWER_MEASUREMENTS_PER_RWZI_BACK_UP out V_SEWER_MEASUREMENTS_PER_RWZI_BACK_UP.txt -S $SQL_OUT -d $DB_OUT -U $USER_OUT -P $PASS_OUT -q -c -t ,

/opt/mssql-tools/bin/bcp VWSDEST.SEWER_MEASUREMENTS_PER_RWZI in V_SEWER_MEASUREMENTS_PER_RWZI_BACK_UP.txt -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,

# Inhabitants per municipality
/opt/mssql-tools/bin/bcp VWSSTATIC.INHABITANTS_PER_MUNICIPALITY in INHABITANTS_PER_MUNICIPALITY.csv -S $SQL_IN -d $DB_IN -U $USER_IN -P $PASS_IN -q -c -t ,
