CREATE   VIEW [VWSREPORT].[V_PBI_Bedbezetting_RECONSTRUCTION]
AS
    SELECT
        CAST([DATE_OF_REPORT] as date)                              AS [Datum]
        ,[IC_BEDS_OCCUPIED_COVID]                                   AS [Bedbezetting IC (COVID)]
        ,[IC_BEDS_OCCUPIED_NON_COVID]                               AS [Bedbezetting IC (non-COVID)]
        ,[IC_BEDS_OCCUPIED_NON_COVID] + [IC_BEDS_OCCUPIED_COVID]    AS [Bedbezetting IC]
        ,[NON_IC_BEDS_OCCUPIED_COVID]                               AS [Bedbezetting]
        ,CAST([DATE_LAST_INSERTED] as date)                         AS [Update datum]
    FROM [VWSDEST].[HOSPITAL_BED_OCCUPANCY]
    WHERE [DATE_LAST_INSERTED] in (
            SELECT MAX([DATE_LAST_INSERTED])
            FROM [VWSDEST].[HOSPITAL_BED_OCCUPANCY]
            GROUP BY CAST([DATE_LAST_INSERTED] as date)
    )