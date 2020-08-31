-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

-- Workflow Casus Landelijk (National figures COVID19)
exec [dbo].[SafeInsertProcess] 'Load_RIVM_COVID_19_Case_National', 'Loads Case National Data', 'RIVM_COVID_19_CASE_NATIONAL', 'https://data.rivm.nl/covid-19/COVID-19_casus_landelijk.json', 'VWSSTAGE.RIVM_COVID_19_Case_National', 'NA', 'Web', 'Ingest', 1
exec [dbo].[SafeInsertProcess] 'Inter_RIVM_COVID_19_Case_National', 'Move Case National data from stage table to intermediate table', 'RIVM_COVID_19_CASE_NATIONAL', 'DBO.SP_RIVM_COVID_19_NATIONAL_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 2
exec [dbo].[SafeInsertProcess] 'Dest_RIVM_COVID_19_Case_National', 'Move Case National data from intermediate table to dest table', 'RIVM_COVID_19_CASE_NATIONAL', 'DBO.SP_POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP', NULL, 'Stored_Procedure', 'NA', 'Execute', 3

-- Workflow Stichting Nice (Figures on intensive care admissions)
exec [dbo].[SafeInsertProcess] 'Load_Foundation_Nice_IC_Intake_Count', 'Loads Foundation Nice data into target table', 'FOUNDATION_NICE_IC_INTAKE_COUNT', 'https://stichting-nice.nl/covid-19/public/new-intake/confirmed/', 'VWSSTAGE.FOUNDATION_NICE_IC_INTAKE_COUNT', 'NA', 'Web', 'Ingest', 1
exec [dbo].[SafeInsertProcess] 'Inter_Foundation_Nice_IC_Intake_Count', 'Move Foundation Nice data from stage table to intermediate table', 'FOUNDATION_NICE_IC_INTAKE_COUNT', 'DBO.SP_FOUNDATION_NICE_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 2
exec [dbo].[SafeInsertProcess] 'Dest_Foundation_Nice_IC_Intake_Count', 'Move Foundation Nice data from intermediate table to dest table', 'FOUNDATION_NICE_IC_INTAKE_COUNT', 'DBO.SP_INTENSIVE_CARE_ADMISSIONS', NULL, 'Stored_Procedure', 'NA', 'Execute', 3

-- Workflow Casus Gemeente (Municipal figures COVID19)
exec [dbo].[SafeInsertProcess] 'Load_RIVM_Municipality', 'Loads COVID19 Municipality data into target table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE', 'https://data.rivm.nl/covid-19/COVID-19_aantallen_gemeente_cumulatief.json', 'VWSSTAGE.RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE', 'NA', 'Web', 'Ingest', 1
exec [dbo].[SafeInsertProcess] 'Inter_RIVM_Municipality', 'Move COVID19 Municipalitye data from stage table to intermediate table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE', 'DBO.SP_RIVM_COVID_19_MUNICIPALITY_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 2
exec [dbo].[SafeInsertProcess] 'Dest_Positive_Tested_People', 'Move COVID19 Municipality data from intermediate table to dest table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE', 'DBO.SP_POSITIVE_TESTED_PEOPLE', NULL, 'Stored_Procedure', 'NA', 'Execute', 3
exec [dbo].[SafeInsertProcess] 'Dest_Hospital_Admissions', 'Move COVID19 Municipality data from intermediate table to dest table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE', 'DBO.SP_HOSPITAL_ADMISSIONS', NULL, 'Stored_Procedure', 'NA', 'Execute', 4
exec [dbo].[SafeInsertProcess] 'Dest_Results_Per_Region', 'Move COVID19 Municipality from intermediate table to dest table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE', 'DBO.SP_RESULTS_PER_REGION', NULL, 'Stored_Procedure', 'NA', 'Execute', 5

-- Workflow Reproduction (Figures on reproduction rate)
exec [dbo].[SafeInsertProcess] 'Load_Reproduction', 'Loads Reproduction data into target table', 'RIVM_REPRODUCTION_NUMBER', 'https://data.rivm.nl/covid-19/COVID-19_reproductiegetal.json', 'VWSSTAGE.RIVM_REPRODUCTION_NUMBER|rivmfiles', 'NA', 'Web', 'Ingest', 1
exec [dbo].[SafeInsertProcess] 'Inter_Reproduction', 'Move Reproduction data from stage table to intermediate table', 'RIVM_REPRODUCTION_NUMBER', 'DBO.SP_RIVM_REPRODUCTION_NUMBER_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 2
exec [dbo].[SafeInsertProcess] 'Dest_Reproduction', 'Move Reproduction data from intermediate table to dest table', 'RIVM_REPRODUCTION_NUMBER', 'DBO.SP_REPRODUCTION_NUMBER', NULL, 'Stored_Procedure', 'NA', 'Execute', 3

-- Workflow Infectious (Figures on infection rates)
exec [dbo].[SafeInsertProcess] 'Load_Infectious', 'Loads Infectious data into target table', 'RIVM_INFECTIOUS_PEOPLE', 'https://data.rivm.nl/covid-19/COVID-19_prevalentie.json', 'VWSSTAGE.RIVM_INFECTIOUS_PEOPLE|rivmfiles', 'NA', 'Web', 'Ingest', 1
exec [dbo].[SafeInsertProcess] 'Inter_Infectious', 'Move Infectious data from stage table to intermediate table', 'RIVM_INFECTIOUS_PEOPLE', 'DBO.SP_RIVM_INFECTIOUS_PEOPLE_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 2
exec [dbo].[SafeInsertProcess] 'Dest_Infectious', 'Move Infectious data from intermediate table to dest table', 'RIVM_INFECTIOUS_PEOPLE', 'DBO.SP_INFECTIOUS_PEOPLE', NULL, 'Stored_Procedure', 'NA', 'Execute', 3

-- Workflow Nursing Homes (Figures on nursing homes)
exec [dbo].[SafeInsertProcess] 'Load_Nursing_Homes', 'Loads Nursing Home data into target table', 'RIVM_NURSING_HOME_INTAKE', 'COVID-19_aantallen_verpleeghuis_perdag.json', 'VWSSTAGE.RIVM_NURSING_HOME_INTAKE|rivmfiles', 'NA', 'Blob', 'Ingest', 1
exec [dbo].[SafeInsertProcess] 'Inter_Nursing_Homes', 'Move Nursing Home  data from stage table to intermediate table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_RIVM_INTAKE_NURSING_HOME_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 2
exec [dbo].[SafeInsertProcess] 'Dest_Nursing_Homes', 'Move Nursing Home  data from intermediate table to dest table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_NURSING_HOME_TOTALS', NULL, 'Stored_Procedure', 'NA', 'Execute', 3

-- Workflow Suspicions General Practitioners (Figures on general practioners information)
exec [dbo].[SafeInsertProcess] 'Load_Suspicions_General_Practitioners', 'Loads GP data into target table', 'NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS', 'Nivel-verdenkingen-COVID-19.json', 'VWSSTAGE.NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS|rivmfiles', 'NA', 'Blob', 'Ingest', 1
exec [dbo].[SafeInsertProcess] 'Inter_Suspicions_General_Practitioners', 'Move GP data from stage table to intermediate table', 'NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS', 'DBO.SP_NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 2
exec [dbo].[SafeInsertProcess] 'Dest_Suspicions_General_Practitioners', 'Move GP data from intermediate table to dest table', 'NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS', 'DBO.SP_SUSPICIONS_GENERAL_PRACTITIONERS', NULL, 'Stored_Procedure', 'NA', 'Execute', 3

-- Workflow Sewer Measurements (Figures on sewage measurements)
exec [dbo].[SafeInsertProcess] 'Load_Sewer_Measurements', 'Loads Sewer Measurements data into target table', 'RIVM_SEWER_MEASUREMENTS', 'https://data.rivm.nl/covid-19/COVID-19_rioolwaterdata.csv', 'VWSSTAGE.RIVM_SEWER_MEASUREMENTS|;', 'NA', 'Web', 'Ingest', 1
exec [dbo].[SafeInsertProcess] 'Inter_Sewer_Measurements', 'Move Sewer Measurements data from stage table to intermediate table', 'RIVM_SEWER_MEASUREMENTS', 'DBO.SP_RIVM_SEWER_MEASUREMENTS_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 2
exec [dbo].[SafeInsertProcess] 'Dest_Sewer_Measurements', 'Move Sewer Measurements data from intermediate table to dest table', 'RIVM_SEWER_MEASUREMENTS', 'DBO.SP_SEWER_MEASUREMENTS', NULL, 'Stored_Procedure', 'NA', 'Execute', 3
exec [dbo].[SafeInsertProcess] 'Dest_Sewer_Measurements_Per_Region', 'Move Sewer Measurements data from intermediate table to dest table with average per region', 'RIVM_SEWER_MEASUREMENTS', 'DBO.SP_SEWER_MEASUREMENTS_PER_REGION', NULL, 'Stored_Procedure', 'NA', 'Execute', 4
exec [dbo].[SafeInsertProcess] 'Dest_Sewer_Measurements_Per_RWZI', 'Move Sewer Measurements data from intermediate table to dest table per sewer treatment plant', 'RIVM_SEWER_MEASUREMENTS', 'DBO.SP_SEWER_MEASUREMENTS_PER_RWZI', NULL, 'Stored_Procedure', 'NA', 'Execute', 5

GO