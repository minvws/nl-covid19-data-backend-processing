# Static data

Static data is in this project used by linking it to transactional data to create more insights, like percentage per total citizens.

In the below table an overview is created of the static table and which stored procedures process them and which destination tables they impact.

| Static data-table                                 | Processed in stored procedure:                    | Impact on destination table: |
|----------                                         | ---------                                         | -------- |
| VWSSTATIC.INHABITANTS_PER_MUNICIPALITY            | DBO.SP_POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY    | VWSDEST.POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY
| VWSSTATIC.INHABITANTS_PER_SAFETY_REGION           | DBO.SP_RESULTS_PER_REGION                         | VWSDEST.RESULTS_PER_REGION
| VWSSTATIC.RWZI_AWZI                               | DBO.SP_SEWER_MEASUREMENTS_PER_RWZI                | VWSDEST.SEWER_MEASUREMENTS_PER_RWZI
| VWSSTATIC.RWZI_GMCODE                             | DBO.SP_SEWER_MEASUREMENTS_PER_MUNICIPALITY        | VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY
| VWSSTATIC.SAFETY_REGIONS_PER_MUNICIPAL            | DBO.SP_SEWER_MEASUREMENTS_PER_RWZI                | VWSDEST.SEWER_MEASUREMENTS_PER_RWZI
| VWSSTATIC.V_NURSING_HOME_LOCATIONS_PER_REGION     | DBO.SP_NURSING_HOMES_PER_REGION                   | VWSDEST.NURSING_HOMES_PER_REGION
