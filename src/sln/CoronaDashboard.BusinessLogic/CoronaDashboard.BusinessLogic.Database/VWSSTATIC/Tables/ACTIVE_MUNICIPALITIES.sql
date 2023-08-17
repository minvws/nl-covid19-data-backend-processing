﻿CREATE TABLE [VWSSTATIC].[ACTIVE_MUNICIPALITIES] (
    [GEMEENTE_CODE]         VARCHAR (10)  NULL,
    [GEMEENTE]              VARCHAR (100) NULL,
    [VEILIGHEIDSREGIO_CODE] VARCHAR (10)  NULL,
    [VEILIGHEIDSREGIO_NAAM] VARCHAR (100) NULL,
    [PROVINCIE_CODE]        VARCHAR (10)  NULL,
    [PROVINCIE_NAAM]        VARCHAR (100) NULL,
    [GGD_CODE]              VARCHAR (10)  NULL,
    [GGD_NAAM]              VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]    DATETIME      NULL
);

