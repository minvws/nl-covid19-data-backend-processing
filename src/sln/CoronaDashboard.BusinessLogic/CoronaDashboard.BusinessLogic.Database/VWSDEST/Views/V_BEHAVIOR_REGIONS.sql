﻿
 --VR_COLLECTION
 CREATE   VIEW [VWSDEST].[V_BEHAVIOR_REGIONS]
 AS
 SELECT 
         dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_REPORT]) AS DATE_START_UNIX
     ,   dbo.CONVERT_DATETIME_TO_UNIX(DATEADD(day, 6, [DATE_OF_REPORT])) AS DATE_END_UNIX
     ,   [NUMBER_OF_PARTICIPANTS]
     ,   VRCODE
     ,   [WASH_HANDS_COMPLIANCE]
     ,   [dbo].[INT_TO_CHANGE]([WASH_HANDS_COMPLIANCE_TREND]) AS [WASH_HANDS_COMPLIANCE_TREND]
     ,   [KEEP_DISTANCE_COMPLIANCE]
     ,   [dbo].[INT_TO_CHANGE]([KEEP_DISTANCE_COMPLIANCE_TREND]) AS [KEEP_DISTANCE_COMPLIANCE_TREND]
     ,   [WORK_FROM_HOME_COMPLIANCE]
     ,   [dbo].[INT_TO_CHANGE]([WORK_FROM_HOME_COMPLIANCE_TREND]) AS [WORK_FROM_HOME_COMPLIANCE_TREND]
     ,   [AVOID_CROWDS_COMPLIANCE]
     ,   [dbo].[INT_TO_CHANGE]([AVOID_CROWDS_COMPLIANCE_TREND]) AS [AVOID_CROWDS_COMPLIANCE_TREND]
     ,   [WEAR_MASK_PUBLIC_INDOORS_COMPLIANCE]
     ,   [dbo].[INT_TO_CHANGE]([WEAR_MASK_PUBLIC_INDOORS_COMPLIANCE_TREND]) AS [WEAR_MASK_PUBLIC_INDOORS_COMPLIANCE_TREND]
     ,   [SNEEZE_COUGH_ELBOW_COMPLIANCE]
     ,   [dbo].[INT_TO_CHANGE]([SNEEZE_COUGH_ELBOW_COMPLIANCE_TREND]) AS [SNEEZE_COUGH_ELBOW_COMPLIANCE_TREND]
     ,   [MAX_VISITORS_COMPLIANCE]
     ,   [dbo].[INT_TO_CHANGE]([MAX_VISITORS_COMPLIANCE_TREND]) AS [MAX_VISITORS_COMPLIANCE_TREND]
     ,   [VENTILATE_HOME_COMPLIANCE]
     ,   [dbo].[INT_TO_CHANGE]([VENTILATE_HOME_COMPLIANCE_TREND]) AS [VENTILATE_HOME_COMPLIANCE_TREND]
     ,   [WASH_HANDS_SUPPORT]
     ,   [dbo].[INT_TO_CHANGE]([WASH_HANDS_SUPPORT_TREND]) AS [WASH_HANDS_SUPPORT_TREND]
     ,   [KEEP_DISTANCE_SUPPORT]
     ,   [dbo].[INT_TO_CHANGE]([KEEP_DISTANCE_SUPPORT_TREND]) AS [KEEP_DISTANCE_SUPPORT_TREND]
     ,   [WORK_FROM_HOME_SUPPORT]
     ,   [dbo].[INT_TO_CHANGE]([WORK_FROM_HOME_SUPPORT_TREND]) AS [WORK_FROM_HOME_SUPPORT_TREND]
     ,   [AVOID_CROWDS_SUPPORT]
     ,   [dbo].[INT_TO_CHANGE]([AVOID_CROWDS_SUPPORT_TREND]) AS [AVOID_CROWDS_SUPPORT_TREND]
     ,   [WEAR_MASK_PUBLIC_INDOORS_SUPPORT]
     ,   [dbo].[INT_TO_CHANGE]([WEAR_MASK_PUBLIC_INDOORS_SUPPORT_TREND]) AS [WEAR_MASK_PUBLIC_INDOORS_SUPPORT_TREND]
     ,   [SNEEZE_COUGH_ELBOW_SUPPORT]
     ,   [dbo].[INT_TO_CHANGE]([SNEEZE_COUGH_ELBOW_SUPPORT_TREND]) AS [SNEEZE_COUGH_ELBOW_SUPPORT_TREND]
     ,   [MAX_VISITORS_SUPPORT]
     ,   [dbo].[INT_TO_CHANGE]([MAX_VISITORS_SUPPORT_TREND]) AS [MAX_VISITORS_SUPPORT_TREND]
     ,   [CURFEW_COMPLIANCE]
     ,   [dbo].[INT_TO_CHANGE]([CURFEW_COMPLIANCE_TREND]) AS [CURFEW_COMPLIANCE_TREND]
     ,   [CURFEW_SUPPORT]
     ,   [dbo].[INT_TO_CHANGE]([CURFEW_SUPPORT_TREND]) AS [CURFEW_SUPPORT_TREND]
     ,   [VENTILATE_HOME_SUPPORT]
     ,   [dbo].[INT_TO_CHANGE]([VENTILATE_HOME_SUPPORT_TREND]) AS [VENTILATE_HOME_SUPPORT_TREND]
     ,   dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
 FROM (
 SELECT
     *,
     RANK() OVER (PARTITION BY VRCODE ORDER BY DATE_OF_REPORT DESC) RANKING
 FROM VWSDEST.BEHAVIOR_PER_REGION
 WHERE DATE_OF_REPORT >=  '2020-02-27 00:00:00.000'
 AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                             FROM VWSDEST.BEHAVIOR_PER_REGION)
 AND VRCODE IS NOT NULL
 AND VRCODE != ' ') T1
 WHERE T1.RANKING =1
 ;