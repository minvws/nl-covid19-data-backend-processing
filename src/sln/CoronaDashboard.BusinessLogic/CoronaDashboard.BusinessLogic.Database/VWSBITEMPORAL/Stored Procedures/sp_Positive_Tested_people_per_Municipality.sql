CREATE   PROCEDURE VWSBITEMPORAL.sp_Positive_Tested_people_per_Municipality (@Date_to_process as DateTime)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @ToDay DateTime = GetDate()

    -- Read the records of the dataset to process from VWSDEST
    DROP TABLE IF EXISTS #Data_to_Process

    SELECT * 
    INTO #Data_to_Process
    FROM VWSDEST.Positive_tested_People_per_municipality
    WHERE Date_Last_Inserted = @Date_to_process


    
  
    -- Now look for records for the same Dates and Municipality code, but with different Values for Cases_7d....
    -- and that have an end-date that is still '31-12-9999'.
    UPDATE A SET END_DATE = CAST(B.Date_last_inserted AS datetime)
    FROM VWSBITEMPORAL.POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY A
        INNER JOIN #Data_to_Process B ON 
                A.Date_of_Report=B.Date_of_Report 
            AND A.MUNICIPALITY_CODE=B.MUNICIPALITY_CODE
    WHERE  ((ISNULL(A.Date_Range_Start,Convert(datetime,'01-01-2020',105)) <> ISNULL(B.Date_Range_Start, Convert(Datetime,'01-01-2020',105))) OR
            (ISNULL(A.Date_of_Reports_Lag,Convert(datetime,'01-01-2020',105)) <> ISNULL(B.Date_of_Reports_Lag, Convert(Datetime,'01-01-2020',105))) OR
            (ISNULL(A.Date_Range_Start_Lag,Convert(datetime,'01-01-2020',105)) <> ISNULL(B.Date_Range_Start_Lag, Convert(Datetime,'01-01-2020',105))) OR
            (ISNULL(A.INFECTED_DAILY_TOTAL,0) <> ISNULL(B.INFECTED_DAILY_TOTAL,0)) OR
            (ISNULL(A.INFECTED_DAILY_INCREASE,0) <> ISNULL(B.INFECTED_DAILY_INCREASE,0)) OR
            (ISNULL(A.[7D_AVERAGE_INFECTED_DAILY_INCREASE_TOTAL],0) <> ISNULL(B.[7D_AVERAGE_INFECTED_DAILY_INCREASE_TOTAL],0)) OR 
            (ISNULL(A.[7D_AVERAGE_INFECTED_DAILY_INCREASE_LAG],0) <> ISNULL(B.[7D_AVERAGE_INFECTED_DAILY_INCREASE_LAG],0)) OR
            (ISNULL(A.[7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE],0) <> ISNULL(B.[7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE],0)))
            AND 
          A.END_DATE = Convert(DateTime, '31-12-9999', 105)  


    -- Now read the records that are 'active' from the Bitemporal dataset
    DROP TABLE IF EXISTS #Bitemporal_Data

    SELECT *
    INTO #Bitemporal_Data
    FROM VWSBITEMPORAL.Positive_tested_People_per_municipality
    WHERE END_DATE > @Today

  -- Insert records that are NOT already present in the current Bitemporal Table
    INSERT INTO VWSBITEMPORAL.Positive_tested_People_per_municipality (
        [DATE_OF_REPORT],
        [DATE_OF_REPORT_UNIX],
        [MUNICIPALITY_CODE],
        [MUNICIPALITY_NAME],
        [INFECTED_DAILY_TOTAL],
        [INFECTED_DAILY_INCREASE],
        [DATE_RANGE_START],
        [DATE_OF_REPORTS_LAG],
        [DATE_RANGE_START_LAG],
        [7D_AVERAGE_INFECTED_DAILY_INCREASE_TOTAL],
        [7D_AVERAGE_INFECTED_DAILY_INCREASE_LAG],
        [7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE],
        Date_Inserted,
        START_DATE,
        END_DATE
    )   
    SELECT 
        A.[DATE_OF_REPORT],
        A.[DATE_OF_REPORT_UNIX],
        A.[MUNICIPALITY_CODE],
        A.[MUNICIPALITY_NAME],
        A.[INFECTED_DAILY_TOTAL],
        A.[INFECTED_DAILY_INCREASE],
        A.[DATE_RANGE_START],
        A.[DATE_OF_REPORTS_LAG],
        A.[DATE_RANGE_START_LAG],
        A.[7D_AVERAGE_INFECTED_DAILY_INCREASE_TOTAL],
        A.[7D_AVERAGE_INFECTED_DAILY_INCREASE_LAG],
        A.[7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE],
        A.[DATE_LAST_INSERTED],
        A.Date_Last_Inserted AS START_DATE,
        CONVERT(DateTime,'31-12-9999', 105) AS END_DATE
    FROM #Data_to_Process A
        LEFT JOIN #Bitemporal_Data B ON 
                A.Date_of_Report=B.Date_of_Report 
            AND A.MUNICIPALITY_CODE=B.MUNICIPALITY_CODE
            AND ISNULL(A.Date_Range_Start, Convert(Datetime,'01-01-2020',105))=ISNULL(B.Date_Range_Start, Convert(Datetime,'01-01-2020',105))
            AND ISNULL(A.Date_of_Reports_Lag, Convert(Datetime,'01-01-2020',105))=ISNULL(B.Date_of_Reports_Lag, Convert(Datetime,'01-01-2020',105))
            AND ISNULL(A.Date_Range_Start_Lag, Convert(Datetime,'01-01-2020',105))=ISNULL(B.Date_Range_Start_Lag, Convert(Datetime,'01-01-2020',105))
            AND ISNULL(A.INFECTED_DAILY_TOTAL,0)=ISNULL(B.INFECTED_DAILY_TOTAL,0)
            AND ISNULL(A.INFECTED_DAILY_INCREASE,0)=ISNULL(B.INFECTED_DAILY_INCREASE,0)
            AND ISNULL(A.[7D_AVERAGE_INFECTED_DAILY_INCREASE_TOTAL],0) = ISNULL(B.[7D_AVERAGE_INFECTED_DAILY_INCREASE_TOTAL],0)
            AND ISNULL(A.[7D_AVERAGE_INFECTED_DAILY_INCREASE_LAG],0) = ISNULL(B.[7D_AVERAGE_INFECTED_DAILY_INCREASE_LAG],0)
            AND ISNULL(A.[7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE],0) = ISNULL(B.[7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE],0)
    WHERE B.Date_of_Report IS NULL

    -- Special attention for records that are the first ones for a
    -- specific Date_of_Report. Their Start_Date will be set to Date_of_Report
    UPDATE A SET START_DATE = A.Date_of_Report
    FROM VWSBITEMPORAL.Positive_tested_people_per_municipality A
        INNER JOIN 
        (
            SELECT Date_Of_Report, Municipality_Code, MIN(Date_Inserted) as Date_Inserted
            FROM VWSBITEMPORAL.Positive_tested_People_per_municipality
            GROUP BY Date_Of_Report, Municipality_Code
        ) B ON A.Date_of_Report=B.Date_of_Report AND A.Municipality_Code=B.Municipality_Code AND A.DATE_INSERTED=B.Date_Inserted


END