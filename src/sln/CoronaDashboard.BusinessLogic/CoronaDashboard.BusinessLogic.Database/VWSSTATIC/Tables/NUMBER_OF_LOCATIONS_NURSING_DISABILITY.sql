﻿CREATE TABLE [VWSSTATIC].[NUMBER_OF_LOCATIONS_NURSING_DISABILITY] (
    [VRCODE]               VARCHAR (50) NOT NULL,
    [COUNT_LOC_NURSERY]    FLOAT (53)   NOT NULL,
    [COUNT_LOC_DISABILITY] FLOAT (53)   NOT NULL,
    [DATE_LAST_INSERTED]   DATETIME     DEFAULT (getdate()) NULL
);

