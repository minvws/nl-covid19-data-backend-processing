﻿CREATE TABLE [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME] (
    [ID]                           INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME]) NOT NULL,
    [AGEGROUP]                     VARCHAR (100)   NULL,
    [DATE]                         DATETIME        NULL,
    [DATE_UNIX]                    BIGINT          NULL,
    [CASES_7D_MOVING_AVERAGE]      DECIMAL (38, 6) NULL,
    [CASES_7D_MOVING_AVERAGE_100K] NUMERIC (38, 6) NULL,
    [CASES]                        INT             NULL,
    [DATE_LAST_INSERTED]           DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME]
    ON [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME]([DATE_LAST_INSERTED] ASC, [DATE_UNIX] ASC);

