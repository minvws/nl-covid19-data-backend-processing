-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE OR ALTER PROCEDURE dbo.SP_BEHAVIOR_VACCINE_WILLINGNESS_BY_AGE_GROUP
AS
BEGIN

/*
  Copy Trello Ticket
  Bereken waarde 'Bereid' per leeftijdsgroep per ronde/wave. Let op: Dit komt als toevoeging op - en dus niet ter vervanging voor - de 'totale' bereidheid.
  Bereid

  Filter de data op:
  - Region_code = NL00
  - Indicator_category = Vaccinatiebereidheid
  - Indicator = Ja
  - Subgroup_category = De volgende vijf mogelijkheden apart per Wave:
  16-24
  25-39
  40-54
  55-69
  70+
  Tel per Wave en per leeftijdsgroep de Value van "Ja". Dat is dan de waarde van de vaccinatiebereidheid voor die Wave voor die leeftijdsgroep. Geef deze waarde terug aan de front end 
  met als datum range een start Date_of_measurement en eind 6 dagen erna. Dus bijvoorbeeld 28-09-20 t/m 04-10-20. Let op dat vanaf wave 7 de optie "Ja_eerst_weten_al_corona_gehad" verdwijnt.
  De percentages die doorgegeven moeten worden aan de front end dienen afgerond te worden op hele percentages. Net zoals nu ook bij het gedragscomponent gebeurd.
  */

  INSERT INTO [VWSDEST].[BEHAVIOR_VACCINE_WILLINGNESS_BY_AGE_GROUP]
  (
    [DATE_OF_MEASUREMENT]
    ,[DATE_START_UNIX]
    ,[DATE_END_UNIX]
    ,[WAVE]
    ,[AGE_GROUP]
    ,[VACCINE_WILLINGNESS]
    )

    SELECT      
        [DATE_OF_MEASUREMENT]
        ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_MEASUREMENT])                  AS DATE_START_UNIX
        ,dbo.CONVERT_DATETIME_TO_UNIX(DATEADD(day, 6, DATE_OF_MEASUREMENT))   AS DATE_END_UNIX
        ,[WAVE]
      ,SUBGROUP                                                               AS [AGE_GROUP]
      ,ROUND([VALUE],0)                                                       AS [VACCINE_WILLINGNESS]
      
              
    FROM [VWSINTER].[VWS_BEHAVIOR]
    WHERE 
      REGION_CODE = 'NL00'
      AND (  -- Selecteer leeftijdsgroepen en totaal
            (SUBGROUP_CATEGORY = 'Alle' AND SUBGROUP = 'Totaal') OR 
            SUBGROUP_CATEGORY = 'Leeftijd'
          )
      AND INDICATOR_CATEGORY = 'Vaccinatiebereidheid'
      AND INDICATOR = 'Ja'
      AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[VWS_BEHAVIOR])
END;