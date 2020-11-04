-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

  UPDATE [DATATINO_PROTO].[VIEWS]
  SET LAST_UPDATE_NAME= 'WEEK_UNIX'
  WHERE [VIEW_NAME] = 'VWSDEST.V_POSITIVE_TESTED_PEOPLE_PERCENTAGE'
  
  UPDATE [DATATINO_PROTO].[VIEWS]
  SET LAST_UPDATE_NAME= 'WEEK_UNIX'
  WHERE [VIEW_NAME] = 'VWSDEST.V_POSITIVE_TESTED_PEOPLE_PERCENTAGE_PER_REGION'