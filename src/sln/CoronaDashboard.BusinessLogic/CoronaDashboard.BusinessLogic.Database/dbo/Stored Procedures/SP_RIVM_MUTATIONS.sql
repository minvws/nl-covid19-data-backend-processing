-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
 CREATE   PROCEDURE [dbo].[SP_RIVM_MUTATIONS]
 AS
 BEGIN
     DECLARE
         @dateLastInserted DATETIME,
         @dateOfStatsStart DATETIME,
         @lastDateMasterDataVars DATETIME,
         @SAMPLE_SIZE INT,
         @TOT_VARIANT_CASES INT,
         @DateOfReport DATETIME,
         @InsertedDatedThisRun DATETIME = SYSDATETIME();
 
     DECLARE @RecalcResult TABLE
     (
         ID               INT,
         VARIANT_CODE     VARCHAR(100),
         VARIANT_CASES    INT,
         Is_subvariant_of VARCHAR(200),
         Shows_on_vws_dashboard BIT,
         VarCases           INT,
         PrevShown          INT,
         [Percentage]       NUMERIC(16,3)
     );
 
     SELECT @lastDateMasterDataVars = MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.MASTERDATA_VARIANTS
 
     DROP TABLE IF EXISTS #LEVERINGEN;
 
     SELECT @dateLastInserted = MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[RIVM_MUTATIONS];
 
     SELECT DISTINCT DATE_OF_STATISTICS_WEEK_START, CAST(0 AS BIT) AS DONE
     INTO #LEVERINGEN
     FROM [VWSINTER].[RIVM_MUTATIONS]
     WHERE DATE_LAST_INSERTED = @dateLastInserted;
 
     WHILE 1 = 1
     BEGIN
         SELECT TOP(1) @dateOfStatsStart = DATE_OF_STATISTICS_WEEK_START
         FROM #LEVERINGEN
         WHERE DONE = 0;
 
         IF @@ROWCOUNT = 0 BREAK;
         
         DROP TABLE IF EXISTS ##VARIANT_CASES_SET;
 
         SELECT  [ID], VARIANT_CODE, VARIANT_NAME, ECDC_CATEGORY, SAMPLE_SIZE, VARIANT_CASES
         INTO ##VARIANT_CASES_SET
         FROM [VWSINTER].[RIVM_MUTATIONS]
         WHERE DATE_LAST_INSERTED = @dateLastInserted AND DATE_OF_STATISTICS_WEEK_START = @dateOfStatsStart;
 
         DELETE @RecalcResult;
 
         INSERT @RecalcResult (ID, VARIANT_CODE, VARIANT_CASES, Is_subvariant_of, Shows_on_vws_dashboard, VarCases, PrevShown)
             EXEC dbo.SP_RECALC_VARIANT_CASES_SET @lastDateMasterDataVars = @lastDateMasterDataVars;
 
         SELECT TOP(1) @SAMPLE_SIZE = SAMPLE_SIZE FROM ##VARIANT_CASES_SET;
 
         SELECT @TOT_VARIANT_CASES = SUM(VarCases) FROM @RecalcResult WHERE Shows_on_vws_dashboard = 1 ;
 
 
         SELECT TOP(1) @DateOfReport = DATE_OF_REPORT
         FROM @RecalcResult AS R
              JOIN [VWSINTER].[RIVM_MUTATIONS] AS M ON R.ID = M.ID
 
         INSERT [VWSDEST].[RIVM_MUTATIONS]
                 ([DATE_OF_REPORT], [DATE_OF_STATISTICS_WEEK_START], [VARIANT_CODE], [VARIANT_NAME], [SORT_ORDER], [IS_VARIANT_OF_CONCERN], [SAMPLE_SIZE], [VARIANT_CASES], [VARIANT_PERCENTAGE], [HAS_HISTORICAL_SIGNIFICANCE], [DATE_LAST_INSERTED])
             SELECT
                 M.DATE_OF_REPORT,
                 M.DATE_OF_STATISTICS_WEEK_START,
                 M.VARIANT_CODE, 
                 M.VARIANT_NAME,
                 V.[SORT_ORDER],
                 --'true' AS IS_VARIANT_OF_CONCERN,
                 M.SAMPLE_SIZE,
                 R.VarCases as VARIANT_CASES,
                 ROUND(CAST(VarCases * 100 AS NUMERIC(16,3)) / @SAMPLE_SIZE, 1) AS VARIANT_PERCENTAGE,
                 --IIF(M.[VARIANT_CODE] IN ('B.1.1.7','B.1.351','P.1','B.1.617.2'), 'true', 'false') AS [HAS_HISTORICAL_SIGNIFICANCE],
                 @InsertedDatedThisRun
             FROM
                 @RecalcResult AS R
                 JOIN [VWSINTER].[RIVM_MUTATIONS] AS M ON R.ID = M.ID
                 JOIN (SELECT * FROM VWSSTATIC.MASTERDATA_VARIANTS WHERE DATE_LAST_INSERTED = @lastDateMasterDataVars) AS V ON R.VARIANT_CODE = V.Variant_code
             WHERE
                 R.Shows_on_vws_dashboard = 1
             
             UNION ALL
 
             SELECT
                 @DateOfReport AS DATE_OF_REPORT,
                 @dateOfStatsStart AS [DATE_OF_STATISTICS_WEEK_START],
                 V.Variant_code                            AS [VARIANT_CODE],
                 V.Variant_code                      AS [VARIANT_NAME],
                 V.[SORT_ORDER],
                 --'true'                                  AS [IS_VARIANT_OF_CONCERN],
                 @SAMPLE_SIZE                             AS [SAMPLE_SIZE],
                 @SAMPLE_SIZE - @TOT_VARIANT_CASES        AS [VARIANT_CASES],
                 ROUND((CAST((@SAMPLE_SIZE - @TOT_VARIANT_CASES) AS FLOAT)*100) /@SAMPLE_SIZE, 1) AS [VARIANT_PERCENTAGE],
                 --'false'                                  AS [HAS_HISTORICAL_SIGNIFICANCE],
                 @InsertedDatedThisRun                    AS [DATE_LAST_INSERTED]
             FROM VWSSTATIC.MASTERDATA_VARIANTS AS V
             WHERE DATE_LAST_INSERTED = @lastDateMasterDataVars
             AND V.Variant_code = 'other_variants'
             AND V.Shows_on_vws_dashboard = 1
 
         DROP TABLE IF EXISTS ##VARIANT_CASES_SET;
 
         UPDATE #LEVERINGEN
             SET DONE = 1
         WHERE DATE_OF_STATISTICS_WEEK_START = @dateOfStatsStart;
 
     END
 END