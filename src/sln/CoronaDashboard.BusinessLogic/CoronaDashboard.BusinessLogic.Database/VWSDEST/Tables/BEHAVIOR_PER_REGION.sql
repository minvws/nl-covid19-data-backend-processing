﻿CREATE TABLE [VWSDEST].[BEHAVIOR_PER_REGION] (
    [ID]                                          INT          DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_BEHAVIOR_PER_REGION]) NOT NULL,
    [DATE_OF_REPORT]                              DATETIME     NULL,
    [VRCODE]                                      VARCHAR (10) NULL,
    [NUMBER_OF_PARTICIPANTS]                      INT          NULL,
    [WASH_HANDS_COMPLIANCE]                       INT          NULL,
    [WASH_HANDS_COMPLIANCE_TREND]                 VARCHAR (10) NULL,
    [KEEP_DISTANCE_COMPLIANCE]                    INT          NULL,
    [KEEP_DISTANCE_COMPLIANCE_TREND]              VARCHAR (10) NULL,
    [WORK_FROM_HOME_COMPLIANCE]                   INT          NULL,
    [WORK_FROM_HOME_COMPLIANCE_TREND]             VARCHAR (10) NULL,
    [AVOID_CROWDS_COMPLIANCE]                     INT          NULL,
    [AVOID_CROWDS_COMPLIANCE_TREND]               VARCHAR (10) NULL,
    [SYMPTOMS_STAY_HOME_COMPLIANCE]               INT          NULL,
    [SYMPTOMS_STAY_HOME_COMPLIANCE_TREND]         VARCHAR (10) NULL,
    [SYMPTOMS_GET_TESTED_COMPLIANCE]              INT          NULL,
    [SYMPTOMS_GET_TESTED_COMPLIANCE_TREND]        VARCHAR (10) NULL,
    [WEAR_MASK_PUBLIC_INDOORS_COMPLIANCE]         INT          NULL,
    [WEAR_MASK_PUBLIC_INDOORS_COMPLIANCE_TREND]   VARCHAR (10) NULL,
    [WEAR_MASK_PUBLIC_TRANSPORT_COMPLIANCE]       INT          NULL,
    [WEAR_MASK_PUBLIC_TRANSPORT_COMPLIANCE_TREND] VARCHAR (10) NULL,
    [SNEEZE_COUGH_ELBOW_COMPLIANCE]               INT          NULL,
    [SNEEZE_COUGH_ELBOW_COMPLIANCE_TREND]         VARCHAR (10) NULL,
    [MAX_VISITORS_COMPLIANCE]                     INT          NULL,
    [MAX_VISITORS_COMPLIANCE_TREND]               VARCHAR (10) NULL,
    [WASH_HANDS_SUPPORT]                          INT          NULL,
    [WASH_HANDS_SUPPORT_TREND]                    VARCHAR (10) NULL,
    [KEEP_DISTANCE_SUPPORT]                       INT          NULL,
    [KEEP_DISTANCE_SUPPORT_TREND]                 VARCHAR (10) NULL,
    [WORK_FROM_HOME_SUPPORT]                      INT          NULL,
    [WORK_FROM_HOME_SUPPORT_TREND]                VARCHAR (10) NULL,
    [AVOID_CROWDS_SUPPORT]                        INT          NULL,
    [AVOID_CROWDS_SUPPORT_TREND]                  VARCHAR (10) NULL,
    [SYMPTOMS_STAY_HOME_SUPPORT]                  INT          NULL,
    [SYMPTOMS_STAY_HOME_SUPPORT_TREND]            VARCHAR (10) NULL,
    [SYMPTOMS_GET_TESTED_SUPPORT]                 INT          NULL,
    [SYMPTOMS_GET_TESTED_SUPPORT_TREND]           VARCHAR (10) NULL,
    [WEAR_MASK_PUBLIC_INDOORS_SUPPORT]            INT          NULL,
    [WEAR_MASK_PUBLIC_INDOORS_SUPPORT_TREND]      VARCHAR (10) NULL,
    [WEAR_MASK_PUBLIC_TRANSPORT_SUPPORT]          INT          NULL,
    [WEAR_MASK_PUBLIC_TRANSPORT_SUPPORT_TREND]    VARCHAR (10) NULL,
    [SNEEZE_COUGH_ELBOW_SUPPORT]                  INT          NULL,
    [SNEEZE_COUGH_ELBOW_SUPPORT_TREND]            VARCHAR (10) NULL,
    [MAX_VISITORS_SUPPORT]                        INT          NULL,
    [MAX_VISITORS_SUPPORT_TREND]                  VARCHAR (10) NULL,
    [DATE_LAST_INSERTED]                          DATETIME     DEFAULT (getdate()) NULL,
    [CURFEW_COMPLIANCE]                           INT          NULL,
    [CURFEW_COMPLIANCE_TREND]                     VARCHAR (10) NULL,
    [CURFEW_SUPPORT]                              INT          NULL,
    [CURFEW_SUPPORT_TREND]                        VARCHAR (10) NULL,
    [VENTILATE_HOME_COMPLIANCE]                   INT          NULL,
    [VENTILATE_HOME_COMPLIANCE_TREND]             VARCHAR (10) NULL,
    [VENTILATE_HOME_SUPPORT]                      INT          NULL,
    [VENTILATE_HOME_SUPPORT_TREND]                VARCHAR (10) NULL,
    [SELFTEST_VISIT_COMPLIANCE]                   INT          NULL,
    [SELFTEST_VISIT_COMPLIANCE_TREND]             VARCHAR (10) NULL,
    [SELFTEST_VISIT_SUPPORT]                      INT          NULL,
    [SELFTEST_VISIT_SUPPORT_TREND]                VARCHAR (10) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_BEHAVIOR_PER_REGION_DLI_VC]
    ON [VWSDEST].[BEHAVIOR_PER_REGION]([DATE_LAST_INSERTED] ASC, [VRCODE] ASC)
    INCLUDE([DATE_OF_REPORT]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_BEHAVIOR_PER_REGION]
    ON [VWSDEST].[BEHAVIOR_PER_REGION]([DATE_LAST_INSERTED] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_BEHAVIOR_PER_REGION_DATE_LAST_INSERTED_DATE_OF_REPORT]
    ON [VWSDEST].[BEHAVIOR_PER_REGION]([DATE_LAST_INSERTED] ASC, [DATE_OF_REPORT] ASC)
    INCLUDE([VRCODE], [NUMBER_OF_PARTICIPANTS], [WASH_HANDS_COMPLIANCE], [WASH_HANDS_COMPLIANCE_TREND], [KEEP_DISTANCE_COMPLIANCE], [KEEP_DISTANCE_COMPLIANCE_TREND], [WORK_FROM_HOME_COMPLIANCE], [WORK_FROM_HOME_COMPLIANCE_TREND], [AVOID_CROWDS_COMPLIANCE], [AVOID_CROWDS_COMPLIANCE_TREND], [WEAR_MASK_PUBLIC_INDOORS_COMPLIANCE], [WEAR_MASK_PUBLIC_INDOORS_COMPLIANCE_TREND], [SNEEZE_COUGH_ELBOW_COMPLIANCE], [SNEEZE_COUGH_ELBOW_COMPLIANCE_TREND], [MAX_VISITORS_COMPLIANCE], [MAX_VISITORS_COMPLIANCE_TREND], [WASH_HANDS_SUPPORT], [WASH_HANDS_SUPPORT_TREND], [KEEP_DISTANCE_SUPPORT], [KEEP_DISTANCE_SUPPORT_TREND], [WORK_FROM_HOME_SUPPORT], [WORK_FROM_HOME_SUPPORT_TREND], [AVOID_CROWDS_SUPPORT], [AVOID_CROWDS_SUPPORT_TREND], [WEAR_MASK_PUBLIC_INDOORS_SUPPORT], [WEAR_MASK_PUBLIC_INDOORS_SUPPORT_TREND], [SNEEZE_COUGH_ELBOW_SUPPORT], [SNEEZE_COUGH_ELBOW_SUPPORT_TREND], [MAX_VISITORS_SUPPORT], [MAX_VISITORS_SUPPORT_TREND], [CURFEW_COMPLIANCE], [CURFEW_COMPLIANCE_TREND], [CURFEW_SUPPORT], [CURFEW_SUPPORT_TREND]);

