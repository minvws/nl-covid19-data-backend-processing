-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

UPDATE [DATATINO_ORCHESTRATOR].[PROCESSES] SET
    NAME = 'https://data.rivm.nl/covid-19/COVID-19_casus_landelijk.csv',
    ARGS = 'VWSSTAGE.RIVM_COVID_19_Case_National|;'
WHERE WORKFLOW_ID= (SELECT ID FROM [DATATINO_ORCHESTRATOR].[WORKFLOWS] WHERE WORKFLOW_NAME='RIVM_COVID_19_CASE_NATIONAL')
AND PROCESS_NAME='Load_RIVM_COVID_19_Case_National'

UPDATE [DATATINO_ORCHESTRATOR].[PROCESSES] SET
    NAME = 'https://data.rivm.nl/covid-19/COVID-19_aantallen_gemeente_per_dag.csv',
    ARGS = 'VWSSTAGE.RIVM_COVID_19_NUMBER_MUNICIPALITY|;'
WHERE WORKFLOW_ID= (SELECT ID FROM [DATATINO_ORCHESTRATOR].[WORKFLOWS] WHERE WORKFLOW_NAME='RIVM_COVID_19_NUMBER_MUNICIPALITY')
AND PROCESS_NAME='Load_RIVM_Municipality_new'