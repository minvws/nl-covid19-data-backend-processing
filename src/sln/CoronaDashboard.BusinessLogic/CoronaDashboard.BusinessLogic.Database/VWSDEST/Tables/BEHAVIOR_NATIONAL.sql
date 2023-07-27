CREATE TABLE [VWSDEST].[BEHAVIOR_NATIONAL] (
    [ID]                                               INT          DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_BEHAVIOR_NATIONAL]) NOT NULL,
    [DATE_OF_REPORT]                                   DATETIME     NULL,
    [NUMBER_OF_PARTICIPANTS]                           INT          NULL,
    [WASH_HANDS_COMPLIANCE]                            INT          NULL,
    [WASH_HANDS_COMPLIANCE_TREND]                      VARCHAR (10) NULL,
    [KEEP_DISTANCE_COMPLIANCE]                         INT          NULL,
    [KEEP_DISTANCE_COMPLIANCE_TREND]                   VARCHAR (10) NULL,
    [WORK_FROM_HOME_COMPLIANCE]                        INT          NULL,
    [WORK_FROM_HOME_COMPLIANCE_TREND]                  VARCHAR (10) NULL,
    [AVOID_CROWDS_COMPLIANCE]                          INT          NULL,
    [AVOID_CROWDS_COMPLIANCE_TREND]                    VARCHAR (10) NULL,
    [SYMPTOMS_STAY_HOME_COMPLIANCE]                    INT          NULL,
    [SYMPTOMS_STAY_HOME_COMPLIANCE_TREND]              VARCHAR (10) NULL,
    [SYMPTOMS_GET_TESTED_COMPLIANCE]                   INT          NULL,
    [SYMPTOMS_GET_TESTED_COMPLIANCE_TREND]             VARCHAR (10) NULL,
    [WEAR_MASK_PUBLIC_INDOORS_COMPLIANCE]              INT          NULL,
    [WEAR_MASK_PUBLIC_INDOORS_COMPLIANCE_TREND]        VARCHAR (10) NULL,
    [WEAR_MASK_PUBLIC_TRANSPORT_COMPLIANCE]            INT          NULL,
    [WEAR_MASK_PUBLIC_TRANSPORT_COMPLIANCE_TREND]      VARCHAR (10) NULL,
    [SNEEZE_COUGH_ELBOW_COMPLIANCE]                    INT          NULL,
    [SNEEZE_COUGH_ELBOW_COMPLIANCE_TREND]              VARCHAR (10) NULL,
    [MAX_VISITORS_COMPLIANCE]                          INT          NULL,
    [MAX_VISITORS_COMPLIANCE_TREND]                    VARCHAR (10) NULL,
    [WASH_HANDS_SUPPORT]                               INT          NULL,
    [WASH_HANDS_SUPPORT_TREND]                         VARCHAR (10) NULL,
    [KEEP_DISTANCE_SUPPORT]                            INT          NULL,
    [KEEP_DISTANCE_SUPPORT_TREND]                      VARCHAR (10) NULL,
    [WORK_FROM_HOME_SUPPORT]                           INT          NULL,
    [WORK_FROM_HOME_SUPPORT_TREND]                     VARCHAR (10) NULL,
    [AVOID_CROWDS_SUPPORT]                             INT          NULL,
    [AVOID_CROWDS_SUPPORT_TREND]                       VARCHAR (10) NULL,
    [SYMPTOMS_STAY_HOME_SUPPORT]                       INT          NULL,
    [SYMPTOMS_STAY_HOME_SUPPORT_TREND]                 VARCHAR (10) NULL,
    [SYMPTOMS_GET_TESTED_SUPPORT]                      INT          NULL,
    [SYMPTOMS_GET_TESTED_SUPPORT_TREND]                VARCHAR (10) NULL,
    [WEAR_MASK_PUBLIC_INDOORS_SUPPORT]                 INT          NULL,
    [WEAR_MASK_PUBLIC_INDOORS_SUPPORT_TREND]           VARCHAR (10) NULL,
    [WEAR_MASK_PUBLIC_TRANSPORT_SUPPORT]               INT          NULL,
    [WEAR_MASK_PUBLIC_TRANSPORT_SUPPORT_TREND]         VARCHAR (10) NULL,
    [SNEEZE_COUGH_ELBOW_SUPPORT]                       INT          NULL,
    [SNEEZE_COUGH_ELBOW_SUPPORT_TREND]                 VARCHAR (10) NULL,
    [MAX_VISITORS_SUPPORT]                             INT          NULL,
    [MAX_VISITORS_SUPPORT_TREND]                       VARCHAR (10) NULL,
    [DATE_LAST_INSERTED]                               DATETIME     DEFAULT (getdate()) NULL,
    [CURFEW_COMPLIANCE]                                INT          NULL,
    [CURFEW_COMPLIANCE_TREND]                          VARCHAR (10) NULL,
    [CURFEW_SUPPORT]                                   INT          NULL,
    [CURFEW_SUPPORT_TREND]                             VARCHAR (10) NULL,
    [SYMPTOMS_STAY_HOME_IF_MANDATORY_SUPPORT]          INT          NULL,
    [SYMPTOMS_STAY_HOME_IF_MANDATORY_SUPPORT_TREND]    VARCHAR (10) NULL,
    [SYMPTOMS_STAY_HOME_IF_MANDATORY_COMPLIANCE]       INT          NULL,
    [SYMPTOMS_STAY_HOME_IF_MANDATORY_COMPLIANCE_TREND] VARCHAR (10) NULL,
    [VENTILATE_HOME_COMPLIANCE]                        INT          NULL,
    [VENTILATE_HOME_COMPLIANCE_TREND]                  VARCHAR (10) NULL,
    [VENTILATE_HOME_SUPPORT]                           INT          NULL,
    [VENTILATE_HOME_SUPPORT_TREND]                     VARCHAR (10) NULL,
    [SELFTEST_VISIT_COMPLIANCE]                        INT          NULL,
    [SELFTEST_VISIT_COMPLIANCE_TREND]                  VARCHAR (10) NULL,
    [SELFTEST_VISIT_SUPPORT]                           INT          NULL,
    [SELFTEST_VISIT_SUPPORT_TREND]                     VARCHAR (10) NULL,
    [POSTTEST_ISOLATION_COMPLIANCE]                    INT          NULL,
    [POSTTEST_ISOLATION_COMPLIANCE_TREND]              VARCHAR (10) NULL,
    [POSTTEST_ISOLATION_SUPPORT]                       INT          NULL,
    [POSTTEST_ISOLATION_SUPPORT_TREND]                 VARCHAR (10) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_BEHAVIOR_NATIONAL_DLI]
    ON [VWSDEST].[BEHAVIOR_NATIONAL]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_OF_REPORT]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_BEHAVIOR_NATIONAL]
    ON [VWSDEST].[BEHAVIOR_NATIONAL]([DATE_LAST_INSERTED] ASC);

