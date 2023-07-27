CREATE   VIEW VWSDEST.V_RIVM_VACCINE_CAMPAIGNS_AND_PLANNED 
 AS
 
  SELECT CAST(VACCINE_CAMPAIGN_ORDER as INT) AS VACCINE_CAMPAIGN_ORDER,
         CAST(DATE_OF_INSERTION_UNIX as BIGINT) as DATE_OF_INSERTION_UNIX,
         VACCINE_CAMPAIGN_NAME_NL,
         VACCINE_CAMPAIGN_NAME_EN,
         CAST(VACCINE_ADMINISTERED_TOTAL as INT) as VACCINE_ADMINISTERED_TOTAL,
         CAST(VACCINE_ADMINISTERED_LAST_WEEK as INT) as VACCINE_ADMINISTERED_LAST_WEEK,
         CAST(DATE_UNIX as BIGINT) as DATE_UNIX,
         CAST(DATE_START_UNIX as BIGINT) as DATE_START_UNIX,
         CAST(DATE_END_UNIX as BIGINT) as DATE_END_UNIX
  FROM 
  (
  	-- Get the rows for the different campaigns 
  	SELECT A.[Key], 
             CAST(A.[Group] as INT) as VACCINE_CAMPAIGN_ORDER, 
             A.Value, 
             dbo.CONVERT_DATETIME_TO_UNIX(A.Date_Last_Inserted) AS DATE_OF_INSERTION_UNIX
  	FROM VWSStage.RIVM_VACCINATION_PLANNED_NL A
  	WHERE LOWER(Category) = 'vaccine_Campaigns.vaccine_Campaigns'
          AND DATE_Last_Inserted=(SELECT MAX(Date_Last_Inserted) FROM VWSStage.RIVM_VACCINATION_PLANNED_NL)
  	
  	UNION
  	
  	SELECT A.[Key], 
             B.[GROUP] as VACCINE_CAMPAIGN_ORDER, 
             CAST(dbo.CONVERT_DATETIME_TO_UNIX(dbo.TRY_CONVERT_TO_DATETIME(A.Value)) as nvarchar(max))as [Value],
             dbo.CONVERT_DATETIME_TO_UNIX(A.Date_Last_Inserted) AS DATE_OF_INSERTION_UNIX
  	FROM VWSStage.RIVM_VACCINATION_PLANNED_NL A
  	CROSS JOIN (
                      SELECT Distinct [GROUP] 
                      FROM VWSStage.RIVM_VACCINATION_PLANNED_NL
                      WHERE NOT (([GROUP] is NULL) OR (UPPER([GROUP])='NULL'))
                          AND DATE_Last_Inserted=(SELECT MAX(Date_Last_Inserted) FROM VWSStage.RIVM_VACCINATION_PLANNED_NL)
                  ) B
  	WHERE UPPER(A.Category) = 'VACCINE_CAMPAIGNS'
  ) t
  -- Now pivot the table per (implicit) Group / VACCINE_CAMPAIGN_ORDER, the rows become columns now
  PIVOT (
  	Min([Value])
  	FOR [Key] IN ([VACCINE_CAMPAIGN_NAME_NL]
  	            , [VACCINE_CAMPAIGN_NAME_EN]
  				, [VACCINE_ADMINISTERED_TOTAL]
  				, [VACCINE_ADMINISTERED_LAST_WEEK]
  				, [DATE_UNIX]
                  ,[DATE_START_UNIX]
  				, [DATE_END_UNIX])
  ) AS Pt